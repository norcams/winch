#!/bin/bash
source /vagrant/vagrant/foreman_puppet.sh
source /vagrant/vagrant/foreman_add_repo.sh
source /vagrant/vagrant/foreman_install.sh
source /vagrant/vagrant/foreman_configure.sh
source /vagrant/vagrant/foreman_netfwd.sh
echo
echo "Manual settings that needs to be changed:"
echo
echo "Administer->Settings->Provisioning:"
echo "query_local_nameservers = true"
echo
echo "Hosts->Provisioning Templates->Kickstart default"
echo "Add 'unsupported_hardware' as a property after 'install'"
echo
