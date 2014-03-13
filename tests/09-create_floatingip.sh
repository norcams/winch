#!/bin/bash -vx
echo "Creating a floating ip:"
FLOATINGIP=$(neutron floatingip-create floatingnet | awk '/\ id\ / { print $4 }'| head -n 1)
echo "Getting the instance id:"
INSTANCEID=$(nova list | awk '/\ test-1\ / { print $2 }' | head -n 1)
echo "Getting the instance router port:"
PORTID=$(neutron port-list -- --device_id=$INSTANCEID | awk '/"10.200.0.2"/ { print $2 }')
echo "Assigning the floating ip to the port:"
neutron floatingip-associate $FLOATINGIP $PORTID
