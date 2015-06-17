if boxfile[:exec].is_a? Hash do
  boxfile[:exec].each do |name, exec|
    execute "sv stop #{name}"
  end
else
  execute 'sv stop app'
end
