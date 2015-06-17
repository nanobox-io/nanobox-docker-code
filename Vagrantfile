# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box     = "nanobox/boot2docker"
  config.vm.box_url = "https://github.com/pagodabox/nanobox-boot2docker/releases/download/v0.0.0/nanobox-boot2docker.box"

  config.vm.synced_folder ".", "/vagrant"

  # Add docker credentials
  config.vm.provision "file", source: "~/.dockercfg", destination: "/root/.dockercfg"

  # Build base image
  config.vm.provision "shell", inline: "docker build -t #{ENV['docker_user']}/code /vagrant"

  # Publish image to dockerhub
  config.vm.provision "shell", inline: "docker push #{ENV['docker_user']}/code"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

end
