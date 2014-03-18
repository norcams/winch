#!/bin/bash

sudo yum -y install http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-10.noarch.rpm
sudo yum -y upgrade puppet facter
sudo service httpd restart

