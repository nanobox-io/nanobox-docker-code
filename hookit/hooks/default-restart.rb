# 'payload' is a helper function within the hookit framework that will parse
# input provided as JSON into a hash with symbol keys.
# https://github.com/pagodabox/hookit/blob/master/lib/hookit/hook.rb#L7-L17
#
# Now we extract the 'boxfile' section of the payload, which is only the
# section of the Boxfile relevant to this service, such as 'web1' or 'worker1'
boxfile = payload[:boxfile] || {}

# if this app can hot-reload and have specified a restart: false
# then we just exit now and let their app do the reloading
if boxfile[:restart] and boxfile[:restart] = false
  exit Hookit::Exit::SUCCESS
end

# with runit, a 'restart' doesn't seem to keep the same environment context
# that the service was started within. Thus, we'll just stop the service and
# then start it again.

if boxfile[:exec].is_a? Hash
  # convert to 'runit' init-type hookit 'service'
  boxfile[:exec].each do |name, exec|
    service name do
      action :disable
    end
    service name do
      action :enable
    end
  end
elsif boxfile[:exec].is_a? String
  service 'app' do
    action :disable
  end
  service 'app' do
    action :enable
  end
end
