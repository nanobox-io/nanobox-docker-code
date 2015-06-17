PORT = registry('env.port')



if boxfile[:exec].is_a? String do
  directory '/etc/service/app/run' do
    recursive true
  end

  template '/etc/service/app/run' do
    mode 0755
    variables ({ exec: boxfile[:exec] })
  end
  
  directory '/etc/service/app/log/run' do
    recursive true
  end

  template '/etc/service/app/log/run' do
    mode 0755
    source 'log-run.erb'
    variables ({ svc: "app" })
  end
elsif boxfile[:exec].is_a? Hash do
  boxfile[:exec].each do |name, exec|
    directory "/etc/service/#{name}/run" do
      recursive true
    end

    template "/etc/service/#{name}/run" do
      mode 0755
      variables ({ exec: exec })
    end
  
    directory "/etc/service/#{name}/log/run" do
      recursive true
    end

    template "/etc/service/#{name}/log/run" do
      mode 0755
      source 'log-run.erb'
      variables ({ svc: name })
    end
  end
else
  directory '/etc/service/app/run' do
    recursive true
  end

  template '/etc/service/app/run' do
    mode 0755
    # this may need to change, but it may never reach this far 
    # if engines did their job
    variables ({ exec: "python -m SimpleHTTPServer #{PORT}" })
  end
  
  directory '/etc/service/app/log/run' do
    recursive true
  end

  template '/etc/service/app/log/run' do
    mode 0755
    source 'log-run.erb'
    variables ({ svc: "app" })
  end
end
