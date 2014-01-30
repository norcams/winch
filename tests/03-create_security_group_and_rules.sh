#!/bin/bash -vx
# Old nova commands:
#nova secgroup-create test "test security group"
#nova secgroup-add-rule test tcp 22 22 0.0.0.0/0
#nova secgroup-add-rule test icmp -1 -1 0.0.0.0/0
quantum security-group-create test
quantum security-group-rule-create --direction ingress --protocol tcp --port_range_min 22 --port_range_max 22 test
quantum security-group-rule-create --protocol icmp --direction ingress test
