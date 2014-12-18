#!/bin/bash
hammer proxy create --name "manager" \
  --url "https://manager.winch.local:8443"
hammer proxy info --name "manager"

# Create a domain named vagrant.local and associate it with DNS on proxy id 1
hammer domain create --name "winch.local" --dns-id 1
hammer domain info --name "winch.local"

hammer subnet create --name "management" \
  --network "172.16.33.0" \
  --mask "255.255.255.0" \
  --gateway "172.16.33.11" \
  --dns-primary "172.16.33.11"
hammer subnet update --name "management" \
  --domain-ids 1 --dhcp-id 1 --tftp-id 1 --dns-id 1
hammer subnet info --name "management"
hammer subnet update --name management --from 172.16.33.20 --to 172.16.33.100

hammer subnet create --name "data" \
  --network "172.16.44.0" \
  --mask "255.255.255.0"
hammer subnet info --name "data"
hammer subnet update --name data --from 172.16.44.20 --to 172.16.44.100

hammer subnet create --name "api" \
  --network "192.168.11.0" \
  --mask "255.255.255.0"
hammer subnet info --name "api"
hammer subnet update --name api --from 192.168.11.20 --to 192.168.11.100

hammer subnet create --name "external" \
  --network "192.168.22.0" \
  --mask "255.255.255.0"
hammer subnet info --name "external"
hammer subnet update --name external --from 192.168.22.20 --to 192.168.22.100

hammer environment create --name "production"
hammer environment info --name "production"

#hammer template create --name "Kickstart_openstack" --type provision --file /vagrant/vagrant/provision/provision_openstack.erb
hammer template create --name "Kickstart default PXELinux ifs" --type provision --file /vagrant/vagrant/provision/provision_kickstart_ifs.erb

#hammer os create --name CentOS --major 6 --minor 6 --description "CentOS 6.6" --family Redhat --architecture-ids 1 --medium-ids 1 --ptable-ids 7
hammer os create --name CentOS --major 7 --minor 0.1406 --description "CentOS 7.0" --family Redhat --architecture-ids 1 --medium-ids 1 --ptable-ids 7

# Get ID of the created OS
#os_id=$(hammer os list | grep "CentOS 6.5" | cut -d" " -f1)
os_id=1

hammer template update --name "Kickstart default PXELinux ifs" --operatingsystem-ids $os_id
#hammer template update --name "Kickstart_openstack" --operatingsystem-ids $os_id
hammer template update --name "Kickstart default" --operatingsystem-ids $os_id

# Get the provision template id
templateid=$(hammer template list --per-page 10000 | grep "Kickstart_openstack"|cut -d" " -f1)
hammer os set-default-template --id $os_id --config-template-id $templateid
# Get the PXElinux template id
pxelinuxid=$(hammer template list --per-page 10000 | grep "Kickstart default PXELinux ifs" | cut -d" " -f1)
hammer os set-default-template --id $os_id --config-template-id $pxelinuxid
# Get the partition table id
parttableid=$(hammer partition-table list --per-page 10000 | grep "Kickstart default" | cut -d" " -f1)
hammer os update --id $os_id --ptable-ids $parttableid

# Import the puppet classes from puppet master
hammer proxy import-classes --environment "production" --id 1

# Get id for openstack controller class
winchcontroller=$(hammer puppet-class list --search "openstack::role::winch_controller" | grep "openstack::role::winch_controller" | cut -d" " -f1)
# Create a host group for virtualbox controller nodes
hammer hostgroup create --name "controller_vbox" --architecture "x86_64" --domain "winch.local" --environment "production" --operatingsystem-id $os_id --medium "CentOS mirror" --ptable "Kickstart default" --puppet-ca-proxy "manager" --puppet-proxy "manager" --puppetclass-ids $winchcontroller --subnet "management"
hammer hostgroup set-parameter --hostgroup "controller_vbox" --name "enable-puppetlabs-repo" --value "true"
hammer hostgroup set-parameter --hostgroup "controller_vbox" --name "infrastructure" --value "vbox"
hammer hostgroup set-parameter --hostgroup "controller_vbox" --name "role" --value "controller"
#hammer hostgroup set-parameter --hostgroup "controller_vbox" --name "enable-addifs" --value "eth1_172.16.44.0/24:eth2_192.168.11.0/24:eth3_192.168.22.0/24"

# Get id for openstack compute class
winchcompute=$(hammer puppet-class list --search "openstack::role::winch_compute" | grep "openstack::role::winch_compute" | cut -d" " -f1)
# Create a host group for virtualbox compute nodes
hammer hostgroup create --name "compute_vbox" --architecture "x86_64" --domain "winch.local" --environment "production" --operatingsystem-id $os_id --medium "CentOS mirror" --ptable "Kickstart default" --puppet-ca-proxy "manager" --puppet-proxy "manager" --puppetclass-ids $winchcompute --subnet "management"
hammer hostgroup set-parameter --hostgroup "compute_vbox" --name "enable-puppetlabs-repo" --value "true"
hammer hostgroup set-parameter --hostgroup "compute_vbox" --name "infrastructure" --value "vbox"
hammer hostgroup set-parameter --hostgroup "compute_vbox" --name "role" --value "compute"
#hammer hostgroup set-parameter --hostgroup "compute_vbox" --name "enable-addifs" --value "eth1_172.16.44.0/24"

# work around Puppet bug #2244 which is fixed in 3.x
sudo mkdir -p /etc/puppet/environments/common/dummy/lib
