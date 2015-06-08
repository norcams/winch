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
- Knowledge about writing custom filters using the `grok-debugger <https://grokdebug.herokuapp.com/>`_.

Logstash
--------

Logstash is an open source tool for receiving, processing and outputting logs. It supports all types of logs and have been used in winch to sentralize, process and extract information coming from OpenStack. All information are saved in an Elasticsearch backend, and visualized with Kibana and other tools. Logstash uses a configuration file where all inputs, filters and outputs are specified. `See configuration details <http://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/conf/logstash.conf>`_.

The most efficient way to send data to Logstash is by using UDP. But in order to check that filteres were working correctly during testing of Logstash the input parameter have been configured to use logfiles rather than UDP. This enabled reruns of the same data over and over in case any filters were misconfigured. All inputs used have been configured this way.

::

        file {
                path => "/var/log/openstack/nova/nova.log"
                type => "nova"
        }
        
All incoming information has been assigned to a type, and by doing this we can make a filter that extracts information whenever a new line of that type appear in the logfile. For example are the second and third grok-filter below extracting available resources in all compute nodes, and this is later sent to Graphite for graphing. The same is done with all API requests and API response times.
        
::

    if [type] == "nova" {
        grok {
			break_on_match => true
			match => [
			 "message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{ID} %{GREEDYDATA:openstack_instance_action}"
			 "message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{RESOURCE_DISK_RAM:Free_disk_ram}",
			 "message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{RESOURCE_CPU:Free_vcpus}"
			 "message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{IP:IP} %{NOVA_INSTANCE_REQUEST:nova_api_request} %{NOTSPACE} %{NOTSPACE} %{INT:nova_response_code} %{NOTSPACE} %{INT} %{NOTSPACE} %{NUMBER:nova_response_time}",
			 "message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{IP:IP} %{QUOTEDSTRING:nova_api_request} %{NOTSPACE} %{INT:nova_response_code} %{NOTSPACE} %{INT} %{NOTSPACE} %{NUMBER:nova_response_time}",
			 "message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{BASE_FILE} %{PATH:openstack_basefile_path}"
			]
		}
	}
	
All instance related events in OpenStack are also tracked. This allows an administrator to follow an instance throught it's lifecycle, from creation to deletion. Here's a summary of all the events that gets extracted in Logstash:


**Nova**

* Available resources on all compute nodes
* All events related to instances
* API requests, API responses and API response times

**Neutron**

* Segment IDs and network IDs
* Accept messages
* API requests, API responses and API response times

**Glance**

* All events related to images
* API requests, API responses and API response times

**Keystone, Cinder & Heat**

* General messages
* API requests, API responses and API response times

To drop unwanted messages or services, regular expressions can be applied in the Logstash configuration directly. The current drop filters consists of the following entries:

::

     if [message] =~ /(?i)Compute_service record|Auditing locally|Loading compute driver|wsgi starting up|Stopping WSGI server|WSGI server has stopped|Skipping periodic task|nova.openstack.common.service|Connected to AMQP server|keystoneclient.middleware.auth_token|Starting new HTTP connection|Returning detailed image list|SIGTERM/ {
                drop {}
     }

This is just one of the many ways regular expressions can be used. Another example is `line 107 <http://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/conf/logstash.conf#L107>`_ where regular expressions have been used, and a special filter is applied if the expression returns true.

The Logstash configuration also has a resource filter if any of the services exceeds its quota. A special filter is applied and the message is tagged so that we can keep a track of these messages more easily. Additionally the configuration also consists of a **greedy** filter that match everything that is not matched elsewhere. This could be messages about loaded extensions, traceback events or just a general _grokparsefailure. These messages are tagged with their own tags respectively, allowing us to go back and adjust filters if necessary.

::

    # All matching filter for grokparsefailures, traceback & extensions
	if "_grokparsefailure" in [tags] {
		if ([message] =~"Traceback") {
			grok {
				match => ["message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{GREEDYDATA:openstack_trace}"]
				add_tag => "openstack_trace"
				remove_tag => "_grokparsefailure"
			}	
		} else if ([message] =~ /(?i)Loaded extension/) {
			grok {
				match => ["message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{GREEDYDATA:openstack_extension}"]
				add_tag => "extension_loaded"
				remove_tag => "_grokparsefailure"
			}	
		} else {
			grok {
				match => ["message", "%{HOSTNAME:openstack_hostname} %{TIMESTAMP_ISO8601:timestamp} %{POSINT:openstack_pid} %{OPENSTACK_LOGLEVEL:openstack_loglevel} %{OPENSTACK_PROG:openstack_program}%{REQ_LIST} %{GREEDYDATA:openstack_message}"]
				add_tag => "openstack_logs"
				add_tag => "unmatched_event"
				remove_tag => "_grokparsefailure"
			}
		}
	}

**Logstash summary**

* Installed with a Puppet module with a ` Logstash manifest file <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/puppet/manifests/logstash.pp>`_
* Installed alongside with `Elasticsearch <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/docs/monitoring_openstack.rst#elasticsearch>`_ and `Kibana <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/docs/monitoring_openstack.rst#kibana>`_
* Logstash configuration files are located in */etc/logstash/conf.d/*
* Logstash grok-patterns are located in */opt/logstash/patterns/*
* Custom OpenStack pattern has been `used <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/conf/openstack_pattern>`_. Otherwise check out the default patterns `here <https://grokdebug.herokuapp.com/patterns>`_.

**Further work**

* More fine tuned filters like `sexilog <https://github.com/sexilog/sexilog/tree/master/logstash/conf.d>`_
* Separate input, filters and output configuration files for easier maintenance

Elasticsearch
-------------

Elasticsearch serves as the backend for all the processed data that comes from Logstash. For now there's only one cluster with a single node that has been defined in the output of the `configuration <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/conf/logstash.conf#L181-L187>`_

::

        elasticsearch {
		host => "localhost:9200"
		protocol => "http"
		cluster => "vagrant_elasticsearch"
		manage_template => true
	}

Elasticsearch saves all the data from Logstash and separates every field in the incoming messages. For instance, if a field value looks like *"Instance spawned successfully"*: Then the term will be broken into three different values *"Instance"*, *"spawned"* and *"successfully"*. 

Since this behavior is by default, Elasticsearch has been configured to display both the separate fields and the raw messages. This enables the administrators to see data in many different ways and count events that occur often. For example can we count which instances that are generating the most data, or how often a specific API request gets executed. This change was done manually by adding two lines in the Elasticsearch template located in */opt/logstash/lib/logstash/outputs/elasticsearch/elasticsearch/elasticsearch-template.json*:

::

              "{name}" : {"type": "string", "index" : "analyzed", "omit_norms" : true, "index_options" : "docs"},
              "{name}.raw" : {"type": "string", "index" : "not_analyzed", "ignore_above" : 256}
              

**Elasticsearch summary**

* Installed with a Puppet module and a `Logstash manifest file <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/puppet/manifests/logstash.pp>`_
* Installed alongside with `Logstash <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/docs/monitoring_openstack.rst#logstash>`_ and `Kibana <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/docs/monitoring_openstack.rst#kibana>`_
* Elasticsearch settings located in /etc/elasticsearch/
* Runs at port 9200



Kibana WIP 
----------

Kibana is a frontend to Elasticsearch and visualizes the information gathered with Logstash. When starting Kibana for the first time make sure to setup the index pattern, which in this case is *logstash-**. Without an index pattern no data will be visible. I first wanted to publish some dashboards in the branch on Github, but this process ended up being a whole lot of work. It's probably best that the intended users setup the dashboards themselves and configure them to their needs.

**Kibana summary**

* Installed with a Puppet module and a `Logstash manifest file <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/puppet/manifests/logstash.pp>`_
* Installed alongside with `Logstash <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/docs/monitoring_openstack.rst#logstash>`_ and `Elasticsearch <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/docs/monitoring_openstack.rst#elasticsearch>`_
* Needs a running Elasticsearch cluster in order to run
* Runs at port 5601


Statsd
------
Statsd provides expanded visualization functionality and is used together with Logstash in order to send API stats to Graphite. This is done by the following Logstash configuration:

::

	if ([nova_api_request] =~ /(?i)"GET|"POST|"DELETE|"HEAD/) {
		statsd {
			timing => [
				"nova.api.response", "%{nova_response_time}",
				"nova.api.response.code.%{nova_response_code}", "%{nova_response_time}"
			]
			increment => "%{nova_response_code}"
		}
	}

	if ([glance_api_request] =~ /(?i)"GET|"POST|"DELETE|"HEAD/) {
		statsd {
			timing => [
				"glance.api.response", "%{glance_response_time}",
				"glance.api.response.code.%{glance_response_code}", "%{glance_response_time}"
			]
			increment => "%{glance_response_code}"
		}	
	}

	if ([neutron_api_request] =~ /(?i)"GET|"POST|"DELETE|"HEAD/) {
	        statsd {
        	        timing => [
				"neutron.api.response", "%{neutron_response_time}",
				"neutron.api.response.code.%{neutron_response_code}", "%{neutron_response_time}"
			]
			increment => "%{neutron_response_code}"
        	}
	}

	if ([keystone_api_request] =~ /(?i)"GET|"POST|"DELETE|"HEAD/) {
	        statsd {
        	        timing => [
				"keystone.api.response", "%{keystone_response_time}",
				"keystone.api.response.code.%{keystone_response_code}", "%{keystone_response_time}"
			]
			increment => "%{keystone_response_code}"
	        }
	}

	if ([cinder_api_request] =~ /(?i)"GET|"POST|"DELETE|"HEAD/) {
	        statsd {
        	        timing => [
				"cinder.api.response", "%{cinder_response_time}",
				"cinder.api.response.code.%{cinder_response_code}", "%{cinder_response_time}"
			]
			increment => "%{cinder_response_code}"
	        }
	}

	if ([heat_api_request] =~ /(?i)"GET|"POST|"DELETE|"HEAD/) {
	        statsd {
	                timing => [
				"heat.api.response", "%{heat_response_time}",
				"heat.api.response.code.%{heat_response_code}", "%{heat_response_time}"
			]
			increment => "%{heat_response_code}"
	        }
	}
    

Statsd needs very limited configuration to run, and the easiest approach is to install Statsd on the same node as Logstash. Below is the configuration used in this project:

::

   {
      graphitePort: 2003, 
      graphiteHost: "192.168.11.19", 
      port: 8125, 
      backends: [ "./backends/graphite" ], 
      graphite: {
        legacyNamespace: false
       }
    }

**Statsd summary**

* Currently installed manually by cloning `Etsy's project on Github <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/puppet/manifests/logstash.pp>`_ and by applying the above configuration
* Needs node.js in order to run *(e.g: node stats.js exampleConfig.js &)*


Graphite
--------

The puppet module that installs Graphite lacks a few things. The puppet module complains about missing folders in the puppetrun. I've used the script below when provisioning in vagrant to fix this:

::

    #!/bin/bash

    if [ "$(hostname | cut -d"." -f1)" == 'graphite' ]; then

        mkdir -p /opt/graphite/
        mkdir -p /opt/graphite/bin

        cp /vagrant/conf/carbon-cache.py /opt/graphite/bin

    fi
    
Graphite's apache configuration also needs a little tweak in order to work properly (this can probably be fixed in the manifest file). I've added the changes manually. These lines should be declared before the VirtualHost

::

    <IfModule !wsgi_module.c>
    LoadModule wsgi_module modules/mod_wsgi.so
    </IfModule>
    
    WSGISocketPrefix /var/run/wsgi
   
And this should be declared inside the VirtualHost:

::
    WSGIScriptAlias / /opt/graphite/conf/graphite.wsgi

Further on the puppet module doesn't create the necessary log files for Graphite either. Another tiny script has been used to fix this:

::

    #!/bin/bash
    cd /opt/graphite/storage/log/webapp
    touch access.log  exception.log  info.log
    
    chmod 775 *.log
    
Additionally the graphite.db doesn't have the correct owner or the correct chmod settings. This should be fixed by doing:

::

    cd /opt/graphite/storage

    chown nobody:nobody graphite.db*
    chmod -R 775 graphite.db*

Also there are two files in Graphite that are very important when it comes to graphing data. These files are storage-schemas.conf and storage-aggregation.conf. These files tells Graphite how graphs are stored and for how long they are stored. 
Both are located in /opt/graphite/conf/, the storage-schemas.conf consists of the following entries:

::

    [statsd]
    pattern = ^stats.*
    retentions = 10s:1d,1m:7d,10m:1y

Stats is the namespace used for all metrics, gauges, counters and timers that comes from Logstash and Statsd. The retention specified means that all 10 second data are stored for 1 day, 1 minute data are stored for 7 days, and 10 minute data are stored for 1 year. These values can easily be adjusted to your own liking. The storage-aggregation.conf consists of:

::

    [min]
    pattern = \.min$
    xFilesFactor = 0.1
    aggregationMethod = min

    [max]
    pattern = \.max$
    xFilesFactor = 0.1
    aggregationMethod = max

    [count]
    pattern = \.count$
    xFilesFactor = 0
    aggregationMethod = sum

    [lower]
    pattern = \.lower(_\d+)?$
    xFilesFactor = 0.1
    aggregationMethod = min

    [upper]
    pattern = \.upper(_\d+)?$
    xFilesFactor = 0.1
    aggregationMethod = max

    [sum]
    pattern = \.sum$
    xFilesFactor = 0
    aggregationMethod = sum

    [gauges]
    pattern = ^.*\.gauges\..*
    xFilesFactor = 0
    aggregationMethod = last

    [default_average]
    pattern = .*
    xFilesFactor = 0.5
    aggregationMethod = average
    

**Graphite summary**

* Installed with a Puppet module and a `Graphite manifest file <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/puppet/manifests/graphite.pp>`_
* Installed alongside with `Grafana <https://github.com/norcams/winch/blob/stable/icehouse-centos6-monitoring/docs/monitoring_openstack.rst#grafana>`_ 
* Gets data from Logstash and Statsd
* Graphite Apache settings are specified in the puppet manifest file
* Runs at port 2003
* Some settings should be fixed in order to avoid manual installation steps (perhaps use another puppet module?)


   



Grafana
-------




Dashing
-------
There are two dashboards that have been configured to work with OpenStack: dashing-ceph and dashing-openstack.
