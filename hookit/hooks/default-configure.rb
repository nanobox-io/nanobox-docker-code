# import some logic/helpers from lib/engine.rb
include NanoBox::Engine

# 'payload' is a helper function within the hookit framework that will parse
# input provided as JSON into a hash with symbol keys.
# https://github.com/pagodabox/hookit/blob/master/lib/hookit/hook.rb#L7-L17

# since the nfs network_dirs will need to be configured and re-configured
# after multiple hooks, we'll need to ensure that the payload required
# can be accessible to hooks where the payload provided doesn't exist.
set(:configure_payload, payload)

# Now we extract the 'boxfile' section of the payload, which is only the
# section of the Boxfile relevant to this service, such as 'web1' or 'worker1'
boxfile = payload[:boxfile] || {}

# 1) make a link for compatibility
link '/var/www' do
  to '/data'
  owner 'gonano'
  group 'gonano'
end

# 2) configure network storage
load File.expand_path("../shared/configure-network_dirs.rb", __FILE__)

# 3) write runit service definitions
if boxfile[:exec].is_a? String

  directory '/etc/service/app' do
    recursive true
  end

  template '/etc/service/app/run' do
    mode 0755
    variables ({
      code_dir: CODE_DIR,
      env_dir: ENV_DIR,
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
        code_dir: CODE_DIR,
        env_dir: ENV_DIR,
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

# 4) Configure narc
template '/opt/gonano/etc/narc.conf' do
  variables ({
    uid: payload[:uid],
    app: "nanobox",
    boxfile: boxfile,
    logtap_host: payload[:logtap_host]
  })
end

directory '/etc/service/narc'

hook_file '/etc/service/narc/run' do
  source 'narc-run'
  mode 0755
end
