#!/bin/bash -vx
CIRROS_IMAGE_ID=$(nova image-list | awk '/CirrOS/ { print $2 }')
nova boot --flavor 1 --image_id ${CIRROS_IMAGE_ID} --security_group test
