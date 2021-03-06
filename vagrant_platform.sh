#!/bin/bash
hash vagrant 2>/dev/null || { echo >&2 "Vagrant is not installed.  Aborting."; exit 1; }

vagrant_ssh (){
  vagrant ssh -c "cd /home/vagrant/leap/configuration/; $1"
}

git clone --branch develop --recursive https://github.com/leapcode/leap_platform.git
cd leap_platform
vagrant up
vagrant_ssh 'mkdir -p files/puppet/modules'
vagrant_ssh 'git submodule add https://github.com/pixelated/puppet-pixelated.git files/puppet/modules/pixelated'
vagrant_ssh 'mkdir -p files/puppet/modules/custom/manifests'
vagrant_ssh 'echo '{}' > services/pixelated.json'
vagrant_ssh "echo 'class custom { include ::pixelated::dispatcher }' > files/puppet/modules/custom/manifests/init.pp"
vagrant_ssh 'export LANG=en_US.UTF-8; export LANGUAGE=en_US.UTF-8; export LC_ALL=en_US.UTF-8; leap deploy'
