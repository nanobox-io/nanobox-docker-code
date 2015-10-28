# import some logic/helpers from lib/engine.rb
include NanoBox::Engine

# with runit, a 'restart' doesn't seem to keep the same environment context
# that the service was started within. Thus, we'll just stop the service and
# then start it again.

# run the stop hook
load File.expand_path("../default-stop.rb", __FILE__)

# re-configure network storage
load File.expand_path("../shared/configure-network_dirs.rb", __FILE__)

# run the start hook
load File.expand_path("../default-start.rb", __FILE__)
