#!/bin/bash -vx
quantum net-create testnet
quantum subnet-create --name testsubnet testnet 10.200.0.0/24
