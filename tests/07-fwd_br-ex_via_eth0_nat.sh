#!/bin/bash -vx
sudo iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
sudo iptables --append FORWARD --in-interface br-ex -j ACCEPT
