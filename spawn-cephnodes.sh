#!/bin/bash

# This is a script that will spawn all Ceph nodes at once
vagrant up ceph01 &
sleep 10
vagrant up ceph02 &
sleep 10
vagrant up ceph03 &
