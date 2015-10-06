# Sanitize network dir
include Hookit::Helper::NFS

module NanoBox
  module Engine
    BUILD_DIR   = '/data'
    CODE_DIR    = '/code'
    ENV_DIR     = '/data/etc/env.d'

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
      symbolize_keys(registry(:configure_payload))
    end

    # helper function to recursively convert hash keys from strings to symbols
    def symbolize_keys(h1)

      # if for some reason a Hash wasn't passed, let's return the original
      if not h1.is_a? Hash
        return h1
      end

      # create a new hash, to contain the symbol'ed keys
      h2 = {}

      # iterate through all of the key/value pairs and convert
      h1.each do |k, v|
        h2[k.to_sym] = begin
          if v.is_a? Hash
            symbolize_keys(v)
          else
            v
          end
        end
      end

      h2
    end

  end
end
