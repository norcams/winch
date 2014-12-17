#!/bin/bash

rhelversion=$(cat /etc/redhat-release | grep release\ 7)

if [ -n "$rhelversion" ]; then
    /bin/yum -y install http://ftp.uninett.no/linux/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
else
    /usr/bin/yum -y install http://ftp.uninett.no/linux/epel/6/i386/epel-release-6-8.noarch.rpm
fi
