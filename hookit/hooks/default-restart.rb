# 'payload' is a helper function within the hookit framework that will parse
# input provided as JSON into a hash with symbol keys.
# https://github.com/pagodabox/hookit/blob/master/lib/hookit/hook.rb#L7-L17
#
# Now we extract the 'boxfile' section of the payload, which is only the
# section of the Boxfile relevant to this service, such as 'web1' or 'worker1'
boxfile = payload[:boxfile] || {}

# with runit, a 'restart' doesn't seem to keep the same environment context
# that the service was started within. Thus, we'll just stop the service and
# then start it again.

# run the stop hook
load File.expand_path("../default-stop.rb", __FILE__)

# re-configure network storage
load File.expand_path("../shared/configure-network_dirs.rb", __FILE__)

# run the start hook
load File.expand_path("../default-start.rb", __FILE__)
