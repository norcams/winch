node controller {
  include ::havana::role::winch_controller
}

node compute {
  include ::havana::role::winch_compute
}

