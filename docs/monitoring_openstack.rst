Monitoring OpenStack
====================

Intro
-----

This document explains how the monitoring setup works in Winch. It explains the different components used and how they
have been installed in order to monitor OpenStack in a simple, yet efficient way.

Requirements
------------
- A running OpenStack environment
- Knowledge about rsyslog forwarding / receiving

Logstash
--------

Logstash is an open source tool for receiving, processing and outputting logs. It supports all types of logs and have been used in winch to sentralize, process and extract information coming from OpenStack. All information are saved in an Elasticsearch backend, and visualized with Kibana and other tools. Logstash uses a configuration file where all inputs, filters and outputs are specified. `See configuration details <http://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/conf/logstash.conf>`_.

The most efficient way to send data to Logstash is by using UDP. But in order to check that filteres were working correctly during testing of Logstash the input parameter have been configured to use logfiles rather than UDP. This enabled reruns of the same data over and over in case any filters were misconfigured. All inputs used have been configured this way.

::

        file {
                path => "/var/log/openstack/nova/nova.log"
                type => "nova"
        }
        
All incoming information has been assigned to a type, and by doing this we can make a filter that extracts information whenever a new line of type "nova" appear in the logfile. For example are the grok-filters below extracting available resources in all compute nodes, which are later sent to Graphite for graphing.
        
::

    if [type] == "nova" {
        grok {
			break_on_match => true
			match => [
			 "message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{RESOURCE_DISK_RAM:Free_disk_ram}",
			 "message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{RESOURCE_CPU:Free_vcpus}"
			]
		}
	}

**Matched events in nova**

* Available resources on all compute nodes
* All events related to instances
* All API requests 

**Installation method**

* Puppet module with a manifest file
* Installed alongside with Elasticsearch and Kibana

Elasticsearch
-------------

Kibana
------

Statsd
------
Only some functions in statsd have been used in this setup. However Statsd provides expanded visualization functionality.

Graphite
--------

**Installation method**

* Puppet module with a manifest file
* Installed alongside with Grafana

In Graphite there are primarly two files that are important in the monitoring setup. Storage-schemas.conf and storage-aggregation.conf, these
files explain how long the graphs are stored, and how they are stored. Both are located in /opt/graphite/conf/. Storage-schemas.conf looks as follows:

::

    [statsd]
    pattern = ^stats.*
    retentions = 10s:1d,1m:7d,10m:1y
   
Stats is the namespace used for all metrics, gauges, counters and timers that comes from Logstash and Statsd. The retention specified means that
all 10 second data are stored for 1 day, 1 minute data are stored for 7 days, and 10 minute data are stored for 1 year. These values can easily
be adjusted but.


Grafana
-------



Dashing
-------
There are two dashboards that have been configured to work with OpenStack: dashing-ceph and dashing-openstack.
