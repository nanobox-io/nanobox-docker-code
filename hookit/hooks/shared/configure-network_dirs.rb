# create /mnt directory if we have network mounts and force unmount any
# existing mounts
if network_dirs.any?

  # ensure 
  directory "/mnt" do
    owner 'gonano'
    group 'gonano'
  end

  # For idempotency
  execute "umount -a -t nfs || true"
end

# raw mount from the service into /mnt
storage.each do |service, info|

  if network_dirs.has_key? service

    # create source directory if doesn't exist
    directory "/mnt/#{service}" do
      owner 'gonano'
      group 'gonano'
      recursive true
    end

    mount "mount #{service}" do
      mount_point "/mnt/#{service}"
      device "#{info[:host]}:/datas"
      options "rw,intr,proto=tcp,vers=3,nolock"
      fstype "nfs"
      action :mount
      not_if  { `mount | grep -c /mnt/#{service}`.to_i > 0 }
    end
  end
end

# Create writable dirs for each storage service used
network_dirs.each do |service, writables|

  writables.each do |write|

    # check to see if the mountpoint is an existing file
    if ::File.exist? "#{CODE_DIR}/#{write}" and not ::File.directory? "#{CODE_DIR}/#{write}"
      # copy the original file onto the mountpoint if it doesn't already exist
      if not ::File.exist? "/mnt/#{service}/#{write}"

        # ensure the parent directory already exists
        directory "/mnt/#{service}#{::File.dirname "/#{write}"}" do
          recursive true
          owner 'gonano'
          group 'gonano'
        end

        # copy the file
        execute "copy original file from source into network store" do
          command "cp -f #{CODE_DIR}/#{write} /mnt/#{service}/#{write}"
          user 'gonano'
        end

        # create a link back to the network-backed file
        link "/mnt/#{service}/#{write}" do
          to "#{CODE_DIR}/#{write}"
          owner 'gonano'
          group 'gonano'
        end

      end

    else
      directory "/mnt/#{service}/#{write}" do
        recursive true
        owner 'gonano'
        group 'gonano'
      end

      # Create mountpoint
      directory "#{CODE_DIR}/#{write}" do
        recursive true
        owner 'gonano'
        group 'gonano'
      end

      mount "mount #{service}" do
        mount_point "#{CODE_DIR}/#{write}"
        device "#{storage[service.to_sym][:host]}:/datas/#{write}"
        options "rw,intr,proto=tcp,vers=3,nolock"
        fstype "nfs"
        action :enable, :mount
        not_if  { `mount | grep -c #{CODE_DIR}/#{write}`.to_i > 0 }
      end

    end
  end
end
