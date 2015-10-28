# Sanitize network dir
include Hookit::Helper::NFS

module NanoBox
  module Engine
    BUILD_DIR = '/data'
    CODE_DIR  = '/code'
    ENV_DIR   = '/data/etc/env.d'

    def storage
      $storage ||= begin
        configure_payload()[:storage] || [] rescue []
      end
    end

    def network_dirs
      $network_dirs ||= begin
        if not storage.empty?
          sanitize_network_dirs(configure_payload)
        else
          []
        end
      end
    end

    def configure_payload
      registry(:configure_payload)
    end

  end
end
