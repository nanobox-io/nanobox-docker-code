if boxfile[:exec].is_a? Hash
  # convert to 'runit' init-type hookit 'service'
  boxfile[:exec].each do |name, exec|
    execute "sv stop #{name}"
  end
else
  execute 'sv stop app'
end
