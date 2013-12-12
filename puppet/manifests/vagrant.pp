node controller {
  include ::grizzly::role::winch_controller
}

node compute {
  include ::grizzly::role::winch_compute
}

