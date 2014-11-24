#!/bin/bash

# Create keystonerc_admin and keystonerc_demo keystonerc_demo2 files
echo "export OS_USERNAME=test
export OS_TENANT_NAME=test
export OS_PASSWORD=abc123
export OS_AUTH_URL=http://192.168.11.12:5000/v2.0/
export PS1='[\u@\h \W(keystone_admin)]\$ '
export OS_NO_CACHE=1" > /root/keystonerc_admin

echo "export OS_USERNAME=demo
export OS_TENANT_NAME=test
export OS_PASSWORD=abc123
export OS_AUTH_URL=http://192.168.11.12:5000/v2.0/
export PS1='[\u@\h \W(keystone_demo)]\$ '
export OS_NO_CACHE=1" > /home/vagrant/keystonerc_demo

echo "export OS_USERNAME=demo2
export OS_TENANT_NAME=test2
export OS_PASSWORD=abc123
export OS_AUTH_URL=http://192.168.11.12:5000/v2.0/
export PS1='[\u@\h \W(keystone_demo2)]\$ '
export OS_NO_CACHE=1" > /home/vagrant/keystonerc_demo2

echo "Keystonerc file locations:"
echo "/root/keystonerc_admin"
echo "/home/vagrant/keystonerc_demo"
echo "/home/vagrant/keystonerc_demo2"


