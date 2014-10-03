#!/bin/bash

## Controller
VBoxManage createvm --name "controller" --register --ostype RedHat_64
VBoxManage modifyvm "controller" --memory 2048 --acpi on --cpus 2 --cpuexecutioncap 100 --cpus 2 --cpuexecutioncap 100 --boot1 disk --boot2 dvd

VBoxManage modifyvm "controller" --nic1 hostonly --hostonlyadapter1 vboxnet0 --cableconnected1 on
VBoxManage modifyvm "controller" --macaddress1 auto --nictype2 82540EM

VBoxManage modifyvm "controller" --nic2 hostonly --hostonlyadapter2 vboxnet1 --cableconnected2 on
VBoxManage modifyvm "controller" --macaddress2 auto --nictype1 82540EM

VBoxManage createhd --filename ./controller.vdi --size 40960
VBoxManage storagectl "controller" --name "IDE Controller" --add ide

VBoxManage storageattach "controller" --storagectl "IDE Controller"  \
    --port 0 --device 0 --type hdd --medium ./controller.vdi

