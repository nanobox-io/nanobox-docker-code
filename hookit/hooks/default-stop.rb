# import some logic/helpers from lib/engine.rb
include NanoBox::Engine

boxfile = configure_payload[:boxfile] || {}

if boxfile[:exec].is_a? Hash
  # convert to 'runit' init-type hookit 'service'
  boxfile[:exec].each do |name, exec|
    service name do
      action :disable
    end
  end
elsif boxfile[:exec].is_a? String
  service 'app' do
    action :disable
  end
end
