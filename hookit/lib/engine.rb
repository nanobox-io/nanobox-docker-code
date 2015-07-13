module NanoBox
  module Engine
    BUILD_DIR   = '/data'
    CODE_DIR    = '/code'
    GONANO_PATH = [
      CODE_DIR,
      "#{CODE_DIR}/bin",
      "#{BUILD_DIR}/sbin",
      "#{BUILD_DIR}/bin",
      '/opt/gonano/sbin',
      '/opt/gonano/bin',
      '/usr/local/sbin',
      '/usr/local/bin',
      '/usr/sbin',
      '/usr/bin',
      '/sbin',
      '/bin'
    ].join (':')

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