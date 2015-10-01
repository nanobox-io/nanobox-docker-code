# import some logic/helpers from lib/engine.rb
include NanoBox::Engine

# Sanitize network dir
include Hookit::Helper::NFS

# 'payload' is a helper function within the hookit framework that will parse
# input provided as JSON into a hash with symbol keys.
# https://github.com/pagodabox/hookit/blob/master/lib/hookit/hook.rb#L7-L17
#
# Now we extract the 'boxfile' section of the payload, which is only the
# section of the Boxfile relevant to this service, such as 'web1' or 'worker1'
boxfile = payload[:boxfile] || {}

# 0) quit out if exec is nil
if boxfile[:exec].nil?
  logvac.puts <<-EOF
▼▼▼▼▼▼▼▼▼▼▼▼ :: ERROR :: ▼▼▼▼▼▼▼▼▼▼▼▼▼▼

The Boxfile is missing an command to exec for 
this service. Review the following guide for 
more information : bit.ly/1RiArU4

▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
      EOF
  exit 1
end

# 1) mount network dirs
# make a link for compatibility
link '/var/www' do
  to '/data'
  owner 'gonano'
  group 'gonano'
end

# Mount storage components
# Temporarily mount each storage service used
if network_dirs.any?
  directory "/mnt" do
    owner 'gonano'
    group 'gonano'
  end

  # For idempotency
  execute "umount -a -t nfs || true"
end

storage.each do |component, info|

  if network_dirs.has_key? component

    # create source directory if doesn't exist
    directory "/mnt/#{component}" do
      owner 'gonano'
      group 'gonano'
      recursive true
    end

    mount "mount #{component}" do
      mount_point "/mnt/#{component}"
      device "#{info[:host]}:/datas"
      options "rw,intr,proto=tcp,vers=3,nolock"
      fstype "nfs"
      action :mount
      not_if  { `mount | grep -c /mnt/#{component}`.to_i > 0 }
    end
  end
end

# Create writable dirs for each storage service used
network_dirs.each do |component, writables|

  writables.each do |write|

    execute "create dirs - handling nested" do
      command "mkdir -p /mnt/#{component}/#{write}"
      user 'gonano'
    end

    if !File.directory?("#{CODE_DIR}/#{write}") && File.exist?("#{CODE_DIR}/#{write}")
      logvac.puts <<-EOF
▼▼▼▼▼▼▼▼▼▼▼▼ :: WARNING :: ▼▼▼▼▼▼▼▼▼▼▼▼▼▼

The network directory '#{write}' is not a folder.
This may cause unexpected behavior. Review the following
guide for more information : bit.ly/1pWDt0N

▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
      EOF
    end

    # Remove mountpoint in case it exists
    execute "rm -rf #{CODE_DIR}/#{write}"

    # Create mountpoint
    directory "#{CODE_DIR}/#{write}" do
      recursive true
      owner 'gonano'
      group 'gonano'
    end
  end
end

# Mount network writable dirs
storage.each do |component, info|

  network_dirs.each do |store, writables|

    if store == component

      writables.each do |write|

        mount "mount #{component}" do
          mount_point "#{CODE_DIR}/#{write}"
          device "#{info[:host]}:/datas/#{write}"
          options "rw,intr,proto=tcp,vers=3,nolock"
          fstype "nfs"
          action :enable, :mount
          not_if  { `mount | grep -c #{CODE_DIR}/#{write}`.to_i > 0 }
        end
      end

    end
  end
end

# 2) write runit service definitions
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

# Configure narc
template '/opt/gonano/etc/narc.conf' do
  variables ({
    uid: payload[:uid],
    app: "nanobox",
    boxfile: boxfile,
    logtap_host: payload[:logtap_host]
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
