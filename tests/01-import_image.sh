#!/bin/bash -vx
[ ! -f cirros-0.3.1-x86_64-disk.img ] && \
  curl -O# http://cdn.download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img
glance image-create \
     --name='CirrOS test image' \
     --disk-format=qcow2 \
     --container-format=bare \
     --public < cirros-0.3.1-x86_64-disk.img
