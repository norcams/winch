#!/bin/bash -vx
CIRROS_IMAGE_ID=$(nova image-list | awk '/CirrOS/ { print $2 }')
nova boot --flavor 1 --image ${CIRROS_IMAGE_ID} --security_group test test-1
