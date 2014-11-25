#!/bin/bash

rhelversion=$(cat /etc/redhat-release | grep release\ 7)

if [ -n "$rhelversion" ]; then
    /bin/rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
    /bin/yum install -y puppet facter
else
    /bin/rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
    /usr/bin/yum install -y puppet facter
fi
