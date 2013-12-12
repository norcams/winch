class grizzly::role::winch_controller inherits ::grizzly::role {
  class { '::grizzly::profile::rabbitmq': } ->
  class { '::grizzly::profile::memcache': } ->
  class { '::grizzly::profile::mysql': } ->
  class { '::grizzly::profile::keystone': } ->
  class { '::grizzly::profile::glance::auth': } ->
  class { '::grizzly::profile::glance::api': } ->
  class { '::grizzly::profile::quantum::router': } ->
  class { '::grizzly::profile::nova::api': }
}
