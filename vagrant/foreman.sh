#!/bin/bash

if [ "$(hostname | cut -d"." -f1)" == 'manager' ]; then

    source /vagrant/vagrant/foreman_puppet.sh
    source /vagrant/vagrant/foreman_add_repo.sh
    source /vagrant/vagrant/foreman_install.sh
    source /vagrant/vagrant/foreman_puppetmaster-config.sh
    source /vagrant/vagrant/foreman_configure.sh
    source /vagrant/vagrant/foreman_netfwd.sh
    echo
    echo "Manual settings that needs to be changed:"
    echo
    echo "Administer->Settings->Provisioning:"
    echo "query_local_nameservers = true"
    echo

fi
