#!/bin/bash
source env-testuser.sh

TENANT_ID=$(keystone tenant-list | awk '/\ test\ / { print $2 }')
quantum net-create --tenant-id ${TENANT_ID} testnet
quantum subnet-create --tenant-id ${TENANT_ID} --name testsubnet testnet 10.200.0.0/24

