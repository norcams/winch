#!/bin/bash
TPATH=`VBoxManage list systemproperties | grep -i "default machine folder:" \
    | cut -b 24- | awk '{gsub(/^ +| +$/,"")}1'`
VMNAME="controller"
VMPATH="$TPATH/$VMNAME"

## Controller
VBoxManage createvm --name "$VMNAME" --register --ostype RedHat_64
VBoxManage modifyvm "$VMNAME" --memory 2048 --acpi on --cpus 2 --cpuexecutioncap 100 --boot1 disk --boot2 dvd

VBoxManage modifyvm "$VMNAME" --nic1 hostonly --hostonlyadapter1 vboxnet0 --cableconnected1 on
VBoxManage modifyvm "$VMNAME" --macaddress1 auto --nictype2 82540EM

VBoxManage modifyvm "$VMNAME" --nic2 hostonly --hostonlyadapter2 vboxnet1 --cableconnected2 on
VBoxManage modifyvm "$VMNAME" --macaddress2 auto --nictype1 82540EM

VBoxManage createhd --filename "$VMPATH/$VMNAME.vdi" --size 40960
VBoxManage storagectl "$VMNAME" --name "SATA Controller" \
    --add sata --controller IntelAHCI --hostiocache on --bootable on
VBoxManage storageattach "$VMNAME" --storagectl "SATA Controller" \
    --type hdd --port 0 --device 0 --medium "$VMPATH/$VMNAME.vdi"

