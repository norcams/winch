Monitoring OpenStack
====================

Intro
-----

This document explains how the monitoring setup works in Winch. It explains the different components used and how they
have been installed in order to monitor OpenStack in an efficient way.

Requirements
------------
- A running OpenStack environment
- Knowledge about rsyslog forwarding / receiving

Logstash
--------

Logstash is an opensource tool for receiving, processing and outputting logs. It supports all types of logs and have been used in winch to sentralize and process information coming from OpenStack logs. All information are saved in an Elasticsearch backend and visualized with Kibana. Logstash uses a configuration file where all inputs, filters and outputs are specified.



**Installation method**


* Puppet module with a manifest file
* Installed alongside with Elasticsearch and 

Elasticsearch
-------------

Kibana
------

Statsd
------
Only some functions in statsd have been used in this setup. 

Graphite
--------

In Graphite there are primarly two files that are important. Storage-schemas.conf and storare-aggregation.conf, these
files explain how long the graphs should be stored and how they are stored.

Grafana
-------

Dashing
-------

