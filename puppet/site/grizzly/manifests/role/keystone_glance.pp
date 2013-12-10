class grizzly::role::keystone_glance inherits ::grizzly::role {
  class { '::grizzly::profile::mysql': } ->
  class { '::grizzly::profile::keystone': } ->
  class { '::grizzly::profile::glance::auth': } ->
  class { '::grizzly::profile::glance::api': }
}

