module NanoBox
  module Engine
    BUILD_DIR   = '/data'
    CODE_DIR    = '/code'

    def storage
      $storage ||= begin
        get(:configure_payload)[:storage] || [] rescue []
      end
    end

    def network_dirs
      $network_dirs ||= begin
        if not storage.empty?
          sanitize_network_dirs(get(:configure_payload))
        else
          []
        end
      end
    end

  end
end
