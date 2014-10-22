node manager {
  include ::openstack::role::winch_manager
}

node controller {
  include ::openstack::role::winch_controller
}

node ceph01 {
  include ::openstack::role::winch_ceph
}

node ceph02 {
  include ::openstack::role::winch_ceph
}

node ceph03 {
  include ::openstack::role::winch_ceph
}

node compute {
  include ::openstack::role::winch_compute
}
