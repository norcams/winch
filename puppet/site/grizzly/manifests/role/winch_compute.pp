class grizzly::role::winch_compute inherits ::grizzly::role {
  class { '::grizzly::profile::quantum::agent': } ->
  class { '::grizzly::profile::nova::compute': }
}

