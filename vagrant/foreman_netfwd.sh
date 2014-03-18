#!/bin/bash -vx
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
sudo iptables --append FORWARD --in-interface eth3 -j ACCEPT
