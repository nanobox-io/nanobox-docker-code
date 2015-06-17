if boxfile[:exec].is_a? Hash
  # convert to 'runit' init-type hookit 'service'
  boxfile[:exec].each do |name, exec|
    execute "sv start #{name}"
  end
else
  execute 'sv start app'
end
