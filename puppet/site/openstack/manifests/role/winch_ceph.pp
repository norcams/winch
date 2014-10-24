class openstack::role::winch_ceph inherits ceph::role {
   class { '::ceph::profile::osd': }
   class { '::ceph::profile::mon': }
}
