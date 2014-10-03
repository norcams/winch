#!/bin/bash

## Compute
VBoxManage createvm --name "compute" --register --ostype RedHat_64
VBoxManage modifyvm "compute" --memory 2048 --acpi on --cpus 2 --cpuexecutioncap 100 --cpus 2 --cpuexecutioncap 100 --boot1 disk --boot2 dvd

VBoxManage modifyvm "compute" --nic1 hostonly --hostonlyadapter1 vboxnet0 --cableconnected1 on
VBoxManage modifyvm "compute" --macaddress1 auto --nictype2 82540EM

VBoxManage modifyvm "compute" --nic2 hostonly --hostonlyadapter2 vboxnet1 --cableconnected2 on
VBoxManage modifyvm "compute" --macaddress2 auto --nictype1 82540EM

VBoxManage createhd --filename ./compute.vdi --size 8192
VBoxManage storagectl "compute" --name "IDE Controller" --add ide

VBoxManage storageattach "compute" --storagectl "IDE Controller"  \
    --port 0 --device 0 --type hdd --medium ./compute.vdi
