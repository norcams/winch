#!/bin/bash

rhelversion=$(cat /etc/redhat-release | grep release\ 7)

# For CentOS7/RHEL7 the rdo release contains puppetlabs repo, creating conflict. Create temp-repo

/bin/wget -P /etc/pki/rpm-gpg/ http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs

if [ -n "$rhelversion" ]; then
#    /bin/rpm -ivh https://repos.fedorapeople.org/repos/openstack/openstack-icehouse/epel-7/rdo-release-icehouse-4.noarch.rpm
#    /usr/bin/yum install -y --enablerepo=puppetlabs-products --enablerepo=puppetlabs-deps puppet facter
echo "[puppettemp-products]
name=Puppet Labs Products - \$basearch
baseurl=http://yum.puppetlabs.com/el/7/products/\$basearch
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
enabled=0
gpgcheck=1

[puppettemp-deps]
name=Puppet Labs Dependencies - \$basearch
baseurl=http://yum.puppetlabs.com/el/7/dependencies/\$basearch
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
enabled=0
gpgcheck=1" >> /etc/yum.repos.d/puppettemp.repo

    /usr/bin/yum install -y --enablerepo=puppettemp-products --enablerepo=puppettemp-deps puppet facter

# Clean up temporary puppet repo
rm -rf /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
rm -rf /etc/yum.repos.d/puppettemp.repo

# install openstack rdo-repo
rpm -i https://repos.fedorapeople.org/repos/openstack/openstack-icehouse/epel-7/rdo-release-icehouse-4.noarch.rpm

else
    /bin/rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
    /usr/bin/yum install -y puppet facter
fi

