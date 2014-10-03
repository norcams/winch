#!/bin/bash

# Let the puppetmaster learn of	our hiera data
sudo ln -s /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml

# Change basemodulepath so the puppetmaster can learn of our puppet modules
sudo mv /etc/puppet/puppet.conf /etc/puppet/puppet.conf_orig

while read line; do
#IFS=" "
    if [[ $line == *basemodulepath* ]]
        then line='    basemodulepath   = /vagrant/puppet/modules:/vagrant/puppet/site'
    fi
    echo -e $line 
done < /etc/puppet/puppet.conf_orig >> /etc/puppet/puppet.conf

# Restart httpd to apply changes to puppet master
/sbin/service httpd restart
