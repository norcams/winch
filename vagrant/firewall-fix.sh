#!/bin/sh
# Work around firewall module bug by flush & stop
iptables -F
iptables -F -t nat
service iptables stop
