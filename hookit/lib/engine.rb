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
  end
end