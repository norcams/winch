#!/bin/bash

if [ "$(hostname | cut -d"." -f1)" == 'manager' ]; then

    yum -y update
    yum -y install kernel-devel-2.6.32-431.el6.x86_64
    yum -y install gcc kernel-devel kernel-headers dkms make bzip2 perl

    /etc/init.d/vboxadd setup

    mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3` vagrant /vagrant
    mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` vagrant /vagrant

    # Persistent /vagrant mount and foreman_netfwd at boot, even if manager is rebootet outside of vagrant
    echo 'mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3` vagrant /vagrant' >> /etc/rc.local
    echo 'mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` vagrant /vagrant' >> /etc/rc.local
    echo 'sh /vagrant/vagrant/foreman_netfwd.sh' >> /etc/rc.local

fi
