# import some logic/helpers from hookit
include Hookit::Helper::Shell 

# 'payload' is a helper function within the hookit framework that will parse
# input provided as JSON into a hash with symbol keys.
# https://github.com/pagodabox/hookit/blob/master/lib/hookit/hook.rb#L7-L17
# 
# Now we extract the 'boxfile' section of the payload, which is only the
# section of the Boxfile relevant to this service, such as 'web1' or 'worker1'
boxfile = payload[:boxfile] || {}

if boxfile[:before_deploy]
  # todo: run the command
end
