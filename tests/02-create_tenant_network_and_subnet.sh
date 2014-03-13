#!/bin/bash -vx
neutron net-create testnet
neutron subnet-create --name testsubnet testnet 10.200.0.0/24
