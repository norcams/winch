#!/bin/bash -vx
quantum net-create --router:external=True floatingnet
quantum subnet-create \
  --name floatingsubnet \
  --allocation-pool start=192.168.22.20,end=192.168.22.29 \
  --gateway 192.168.22.11 \
  --enable_dhcp=False \
  floatingnet 192.168.22.0/24
