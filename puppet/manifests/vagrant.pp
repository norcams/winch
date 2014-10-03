node controller {
  include ::openstack::role::winch_controller
}

node compute {
  include ::openstack::role::winch_compute
}

node manager {
  include ::openstack::role::winch_manager
}

