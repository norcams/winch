#!/bin/bash

# Add ceph repos and hosts entries if the hostname starts with ceph

machinename=$(hostname | cut -d"." -f1)
if [ $(echo "${machinename:0:4}") == 'ceph' ]; then

    sudo yum -y install http://ftp.uninett.no/linux/epel/6/i386/epel-release-6-8.noarch.rpm

    echo "[ceph]
name=Ceph packages for $basearch
baseurl=http://ceph.com/rpm-firefly/el6//\$basearch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=http://ceph.com/rpm-firefly/el6//noarch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=http://ceph.com/rpm-firefly/el6//SRPMS
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc" > /etc/yum.repos.d/ceph.repo

    echo "[ceph-extras]
name=Ceph Extras Packages
baseurl=http://ceph.com/packages/ceph-extras/rpm/rhel6/\$basearch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc

[ceph-extras-noarch]
name=Ceph Extras noarch
baseurl=http://ceph.com/packages/ceph-extras/rpm/rhel6/noarch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc

[ceph-extras-source]
name=Ceph Extras Sources
baseurl=http://ceph.com/packages/ceph-extras/rpm/rhel6/SRPMS
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc" > /etc/yum.repos.d/ceph-extras.repo

thismachine=$(hostname -s)
    echo "172.16.33.13 ceph01.winch.local ceph01
172.16.33.14 ceph02.winch.local ceph02
172.16.33.15 ceph03.winch.local ceph03
127.0.0.1   $thismachine.winch.local $thismachine localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
fi
