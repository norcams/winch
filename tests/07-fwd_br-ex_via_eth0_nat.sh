#!/bin/bash -vx
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --append FORWARD --in-interface br-ex -j ACCEPT
