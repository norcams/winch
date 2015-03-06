#!/bin/bash

service openstack-ceilometer-alarm-evaluator restart
#service openstack-cinder-scheduler restart
service openstack-keystone restart
service openstack-nova-novncproxy restart
service openstack-ceilometer-alarm-notifier restart
#service openstack-cinder-volume restart
service openstack-nova-api restart
service openstack-nova-objectstore restart
service openstack-ceilometer-api restart
service openstack-glance-api restart
service openstack-nova-cert restart
service openstack-nova-scheduler restart
service openstack-ceilometer-central restart
service openstack-glance-registry restart
service openstack-nova-compute restart
service openstack-nova-spicehtml5proxy restart
service openstack-ceilometer-collector restart
service openstack-glance-scrubber restart
service openstack-nova-conductor restart
service openstack-nova-xvpvncproxy restart
service openstack-ceilometer-notification restart
service openstack-heat-api restart        
service openstack-nova-console restart          
#service openstack-cinder-api restart        
service openstack-heat-api-cfn restart    
service openstack-nova-consoleauth restart       
#service openstack-cinder-backup restart         
service openstack-heat-engine restart   
service openstack-nova-metadata-api restart

