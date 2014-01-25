#!/bin/bash -vx
VBoxManage list hostonlyifs | awk '/^Name/ { print  }' | xargs -n 1 VBoxManage hostonlyif remove
