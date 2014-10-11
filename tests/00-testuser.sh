#!/bin/bash
export OS_USERNAME=test
export OS_TENANT_NAME=test
export OS_PASSWORD=abc123
export OS_AUTH_URL=http://192.168.11.12:5000/v2.0/
export PS1='[\u@\h \W(keystone_demo)]\$ '
export OS_NO_CACHE=1

# Run keystone to get tenant-id - tenant is already created by Puppet
TENANT_ID=$(keystone tenant-list | awk '/\ demo\ / { print $2 }')
