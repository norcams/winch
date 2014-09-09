node controller {
  include ::openstack::role::winch_controller
}

node compute {
  include ::openstack::role::winch_compute
}

