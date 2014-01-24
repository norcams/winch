#!/bin/bash -vx
nova secgroup-create test "test security group"
nova secgroup-add-rule test tcp 22 22 0.0.0.0/0
nova secgroup-add-rule test icmp -1 -1 0.0.0.0/0
