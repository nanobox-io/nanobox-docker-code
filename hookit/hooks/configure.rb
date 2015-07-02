# import some logic/helpers from lib/engine.rb
include NanoBox::Engine

# import some logic/helpers from hookit
include Hookit::Helper::Shell 

# 'payload' is a helper function within the hookit framework that will parse
# input provided as JSON into a hash with symbol keys.
# https://github.com/pagodabox/hookit/blob/master/lib/hookit/hook.rb#L7-L17
# 
# Now we extract the 'boxfile' section of the payload, which is only the
# section of the Boxfile relevant to this service, such as 'web1' or 'worker1'
boxfile = payload[:boxfile] || {}

# 1) prepare environment variables
env_vars = ::Dir.glob('/data/etc/environment.d/*').inject({}) do |result, file|
  name = escape_shell_string(::File.basename(file))
  value = escape_shell_string(::File.read(file))
  result[name] = value
  result
end

# 2) write runit service definitions
if boxfile[:exec].is_a? String

  directory '/etc/service/app' do
    recursive true
  end

  template '/etc/service/app/run' do
    mode 0755
    variables ({ 
      path: GONANO_PATH,
      code_dir: CODE_DIR,
      env_vars: env_vars,
      exec: boxfile[:exec]
    })
  end
  
  directory '/etc/service/app/log' do
    recursive true
  end

  template '/etc/service/app/log/run' do
    mode 0755
    source 'log-run.erb'
    variables ({ svc: "app" })
  end

elsif boxfile[:exec].is_a? Hash

  boxfile[:exec].each do |name, exec|
    directory "/etc/service/#{name}" do
      recursive true
    end

    template "/etc/service/#{name}/run" do
      mode 0755
      variables ({
        path: GONANO_PATH,
        code_dir: CODE_DIR,
        env_vars: env_vars,
        exec: exec
      })
    end
  
    directory "/etc/service/#{name}/log" do
      recursive true
    end

    template "/etc/service/#{name}/log/run" do
      mode 0755
      source 'log-run.erb'
      variables ({ svc: name })
    end
  end
end

# Configure narc
template '/opt/gonano/etc/narc.conf' do
  variables ({
    uid: payload[:uid],
    app: "nanobox",
    boxfile: boxfile,
    logtap: payload[:logtap_uri]
  })
end

directory '/etc/service/narc'

file '/etc/service/narc/run' do
  mode 0755
  content <<-EOF
#!/bin/sh -e
export PATH="/opt/local/sbin:/opt/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/gonano/sbin:/opt/gonano/bin"

exec /opt/gonano/bin/narcd /opt/gonano/etc/narc.conf
  EOF
end
