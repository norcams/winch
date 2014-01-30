#!/bin/bash -vx
sudo yum -y -q install sshpass
NETNS=$(sudo ip netns | grep qdhcp | head -n1)
sudo ip netns exec $NETNS sshpass -p 'cubswin:)' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no cirros@10.200.0.2 ping -c 5 8.8.8.8
