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
  ensure  => '/vagrant/logstash.conf',
  require => [ Class['logstash'] ],
}

file { '/opt/logstash/patterns/openstack_pattern':
  ensure  => '/vagrant/openstack_pattern',
  require => [ Class['logstash'] ],
}

file { '/opt/logstash/patterns/yum_pattern':
  ensure  => '/vagrant/yum_pattern',
  require => [ Class['logstash'] ],
}

# Kibana
#class { 'kibana':
#  elasticsearch_url  => "http://192.168.11.17:9200",
#  webserver => 'apache',
#  install_url => 'https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-linux-x64.zip',
#}

#exec {'start kibana':
#command => '/opt/kibana-4.0.0-linux-x64/bin/kibana & ',
# require => [ Class['kibana']]
#}

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