module NanoBox
  module Engine
    BUILD_DIR   = '/data'
    CODE_DIR    = '/code'
    ENV_DIR     = '/data/etc/env.d'

    def storage
      $storage ||= begin
        payload[:storage] || []
      end
    end

    def network_dirs
      $network_dirs ||= begin
        if payload[:storage]
          sanitize_network_dirs(payload)
        else
          []
        end
      end
    end

  end
end
