class grizzly::role::keystone_only inherits ::grizzly::role {
  class { '::grizzly::profile::mysql': } ->
  class { '::grizzly::profile::keystone': }
}
