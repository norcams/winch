# Hello Vagrant!

We play around a little with Vagrant to get a feel for the tool. Nothing complicated, if you've used Vagrant before you should skip this!

## Requirements

* A working installation of VirtualBox and Vagrant
* A decent internet connection to download a <1GB Vagrant box

## Vagrant 

Vagrant uses image templates as its source for quickly bringing up a new virtual machine. These base images are called _boxes_ in Vagrant. A box is added to Vagrant with `vagrant box add`. Open a command line and add the box we are going to use

    vagrant box add centos http://bit.ly/1aNNghN

This might take a while to finish, the box is around 500mb to download. While waiting for it to complete you could skim through the [getting started guide][vagrant-guide] - obviously skipping the commands - just to get a feel of what you are doing.

After the add-command has completed we're ready to go. All VMs controlled by Vagrant must first be defined in a `Vagrantfile` so that will be the very first file of our project. Create an empty folder somewhere convenient for you to find, best place would probably be where you normally keep code or documents. Then initialize a Vagrantfile using the box name we defined above.

    mkdir -p ~/code/testproject
    cd ~/code/testproject
    vagrant init centos6

This creates a `Vagrantfile` with the bare minimum settings needed. Open it up in your editor and read through the settings available. To run your newly defined VM do

    vagrant up

When the boot process has completed you will be taken back to your command prompt. Next, ssh into it and play around a bit.

    vagrant ssh

The `vagrant` user you will be logged in as has sudo rights so you are free to play around. It can actually be quite fun to break the OS doing things you normally wouldn't. Another thing to notice, the `/vagrant` folder inside the VM is actually a mounted network share of your project folder. This makes it easy to edit files using tools on your host computer while they are _shared inside the VM_, part of what makes Vagrant so flexible.

When you are finished playing around, if you do

    vagrant destroy

the VM you were playing with will be discarded. Have a look at the other commands that are available by doing `vagrant help`. Possibly the most important one is _provision_ which you might want to [read about as a concept][vagrant-provision] at vagrantup.com. Take note that Vagrant has a lot of different mechanisms for provisioning, it supports both Ansible, Chef and CFengine in addition to shell scripts.


[vagrant-provision]:    http://docs.vagrantup.com/v2/provisioning/index.html
