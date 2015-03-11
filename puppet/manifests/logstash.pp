Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/opt']
}

# Preinstall
stage { 'preinstall':
  before => Stage['main']
}

class install_prereqs {
  package { jdk:
    ensure  => present,
    name => 'java-1.7.0-openjdk',
  } 

  package { wget:
    ensure  => present,
    name => 'wget',
  }
}

class { 'install_prereqs':
  stage => preinstall
}

# Elasticsearch
class { 'elasticsearch':

  manage_repo  => true,
  repo_version => '1.4',
  ensure => 'present',
  package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.noarch.rpm'
}

elasticsearch::instance { 'monitoring-01':
  config => {
  'cluster.name' => 'vagrant_elasticsearch',
  'index.number_of_replicas' => '0',
  'index.number_of_shards'   => '1',
  'network.host' => '0.0.0.0'
},        # Configuration hash
  init_defaults => { }, # Init defaults hash
}

# Logstash
class { 'logstash':
  autoupgrade  => true,
  ensure       => 'present',
  manage_repo  => true,
  repo_version => '1.4',
  require      => [ Class['install_prereqs'], Class['elasticsearch'] ],
}

file { '/etc/logstash/conf.d/logstash.conf':
  ensure  => '/vagrant/conf/logstash.conf',
  require => [ Class['logstash'] ],
}

file { '/opt/logstash/patterns/openstack_pattern':
  ensure  => '/vagrant/conf/openstack_pattern',
  require => [ Class['logstash'] ],
}

file { '/opt/logstash/patterns/yum_pattern':
  ensure  => '/vagrant/conf/yum_pattern',
  require => [ Class['logstash'] ],
}

class { '::kibana4':
  package_ensure    => '4.0.0-linux-x64',
  package_provider  => 'archive',
  symlink           => false,
  manage_user       => true,
  kibana4_user      => kibana4,
  kibana4_group     => kibana4,
  kibana4_gid       => 200,
  kibana4_uid       => 200,
  elasticsearch_url => 'http://localhost:9200',
}

# Start services
exec {'start logstash':
  command => 'service logstash start',
  require => [ Class['logstash']]
}

es_instance_conn_validator { 'monitoring-01' :
  server => '192.168.11.17',
  port   => '9200',
}

exec {'start elasticsearch':
  command => 'service elasticsearch-monitoring-01 start',
  require => es_instance_conn_validator['monitoring-01']
}

exec {'start kibana': 	
  command => 'service kibana4 start', 	
  require => es_instance_conn_validator['monitoring-01']
}
