#!/bin/bash
# Add ceph repos and hosts entries if the hostname starts with ceph

machinename=$(hostname | cut -d"." -f1)
if [ $(echo "${machinename:0:4}") == 'ceph' ]; then

    sudo yum -y install http://ftp.uninett.no/linux/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

    echo "[Ceph]
name=Ceph packages for $basearch
baseurl=http://ceph.com/rpm-firefly/el7/\$basearch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc
priority=1

[Ceph-noarch]
name=Ceph noarch packages
baseurl=http://ceph.com/rpm-firefly/el7/noarch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc
priority=1

[ceph-source]
name=Ceph source packages
baseurl=http://ceph.com/rpm-firefly/el7/SRPMS
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc
priority=1" > /etc/yum.repos.d/ceph.repo

    echo "[Ceph-el7]
name=Ceph-el7
baseurl=http://eu.ceph.com/rpms/rhel7/noarch/
enabled=1
gpgcheck=0" > /etc/yum.repos.d/ceph-el7.repo

thismachine=$(hostname -s)
    echo "172.16.33.13 ceph01.winch.local ceph01
172.16.33.14 ceph02.winch.local ceph02
172.16.33.15 ceph03.winch.local ceph03
127.0.0.1   $thismachine.winch.local $thismachine localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" > /etc/hosts
fi
