#!/bin/bash

# This script will create a VirtualBox compute node and register it in foreman.

if [ -z "$(vagrant status manager 2>&1 | grep manager | grep running)" ]; then
    echo "You must have a running manager vagrant instance and changedir to the winch directory"
else
    TPATH=`VBoxManage list systemproperties | grep -i "default machine folder:" \
        | cut -b 24- | awk '{gsub(/^ +| +$/,"")}1'`
    VMNAME="compute"
    VMPATH="$TPATH/$VMNAME"

    VBoxManage createvm --name "$VMNAME" --register --ostype RedHat_64
    VBoxManage modifyvm "$VMNAME" --memory 2048 --acpi on --cpuexecutioncap 100 --cpus 2 --boot1 disk --boot2 dvd

    VBoxManage modifyvm "$VMNAME" --nic1 hostonly --hostonlyadapter1 vboxnet0 --cableconnected1 on
    VBoxManage modifyvm "$VMNAME" --macaddress1 auto --nictype2 82540EM

    VBoxManage modifyvm "$VMNAME" --nic2 hostonly --hostonlyadapter2 vboxnet1 --cableconnected2 on
    VBoxManage modifyvm "$VMNAME" --macaddress2 auto --nictype1 82540EM

    VBoxManage createhd --filename "$VMPATH/$VMNAME.vdi" --size 8196
    VBoxManage storagectl "$VMNAME" --name "SATA Controller" \
        --add sata --controller IntelAHCI --hostiocache on --bootable on
    VBoxManage storageattach "$VMNAME" --storagectl "SATA Controller" \
        --type hdd --port 0 --device 0 --medium "$VMPATH/$VMNAME.vdi"

    VBoxManage showvminfo compute | grep "MAC" | cut -d"," -f1

    # Define host in foreman
    # Find the MAC address for the primary interface
    macaddress=$(vboxmanage showvminfo compute --machinereadable | grep macaddress1 | cut -d"\"" -f 2)
    hammercommand="sudo hammer host create --architecture x86_64 --domain winch.local --environment production --hostgroup compute_vbox --mac $macaddress --medium CentOS\ mirror --name compute --ptable Kickstart\ default --provision-method build --puppet-ca-proxy-id 1 --puppet-proxy-id 1 --subnet management --root-password 'Test123!'"

    echo "Registering host in foreman"
    vagrant ssh manager -c "$hammercommand"
fi
