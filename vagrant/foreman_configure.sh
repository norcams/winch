#!/bin/bash
hammer proxy create --name "installer" \
  --url "https://installer.winch.local:8443"
hammer proxy info --name "installer"

# Create a domain named vagrant.local and associate it with DNS on proxy id 1
hammer domain create --name "winch.local" --dns-id 1
hammer domain info --name "winch.local"

hammer subnet create --name "vagrant" \
  --network "172.16.188.0" \
  --mask "255.255.255.0" \
  --gateway "172.16.188.11" \
  --dns-primary "172.16.188.11"
hammer subnet update --name "vagrant" \
  --domain-ids 1 --dhcp-id 1 --tftp-id 1 --dns-id 1
hammer subnet info --name "vagrant"

hammer environment create --name "production"
hammer environment info --name "production"

hammer os create --name CentOS --major 6 --minor 5 --description "CentOS 6.5" --family Redhat --architecture-ids 1 --medium-ids 1 --ptable-ids 6
hammer template update --id 13 --operatingsystem-ids 1
hammer template update --id 11 --operatingsystem-ids 1

# work around Puppet bug #2244 which is fixed in 3.x
sudo mkdir -p /etc/puppet/environments/common/dummy/lib

