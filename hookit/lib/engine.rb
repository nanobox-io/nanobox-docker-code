# Sanitize network dir
include Hookit::Helper::NFS

module NanoBox
  module Engine
    BUILD_DIR   = '/data'
    CODE_DIR    = '/code'
    ENV_DIR     = '/data/etc/env.d'

    def storage
      $storage ||= begin
        registry(:configure_payload)[:storage] || [] rescue []
      end
    end

    def network_dirs
      $network_dirs ||= begin
        if not storage.empty?
          sanitize_network_dirs(registry(:configure_payload))
        else
          []
        end
      end
    end

  end
end
