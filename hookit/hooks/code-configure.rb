boxfile = payload[:boxfile]

if boxfile[:exec].is_a? String
  directory '/etc/service/app' do
    recursive true
  end

  template '/etc/service/app/run' do
    mode 0755
    variables ({ exec: boxfile[:exec] })
  end
  
  directory '/etc/service/app/log' do
    recursive true
  end

  template '/etc/service/app/log/run' do
    mode 0755
    source 'log-run.erb'
    variables ({ svc: "app" })
  end
elsif boxfile[:exec].is_a? Hash
  boxfile[:exec].each do |name, exec|
    directory "/etc/service/#{name}" do
      recursive true
    end

    template "/etc/service/#{name}/run" do
      mode 0755
      variables ({ exec: exec })
    end
  
    directory "/etc/service/#{name}/log" do
      recursive true
    end

    template "/etc/service/#{name}/log/run" do
      mode 0755
      source 'log-run.erb'
      variables ({ svc: name })
    end
  end
end
