# Excercise 0: The setup

This excercise sets up a computer so that it is possible to use it for Puppet code development.

## Requirements

There are some minimal requirements before starting out.

* Basic knowledge of [git][git] and [command line tools][cli-thw]
* A multi-core desktop or laptop computer running Linux or OSX with at least 4gb of RAM
* A SSD drive for storing virtual machines

If you are missing some of these things might still work but possibly be less enjoyable. Most importantly, use your fastest hardware! Running virtual machines on a five year old laptop may seem acceptable at first but really isn't. You _will_ grow tired of waiting for reboots and configuration runs to complete.

Using Windows as the host OS might be possible but is currently untested.

## Install the software stack

The software stack we need on the host computer consists of three main components. You might have some of these installed already.

### git

We are going to use git as our version control system. The [Pro Git book][progit] by Scott Chacon is an excellent go-to reference, please use that to get [installation][progit-install] and [first-time setup][progit-setup] done.

### VirtualBox

VirtualBox will be our back-end virtualization engine for Vagrant. The Vagrant ecosystem is currently fast-moving so make sure to get the latest and greatest version directly from the _Downloads_ page on [www.virutalbox.org][virtualbox-dl].

The installation instructions for Linux includes steps to add the VirtualBox package repo to your package manager. This makes updating easier or even automatic in the future so I recommend that you do so.

By default VirtualBox will create all virtual machines in a folder named `VirtualBox VMs` in your home folder. Depending on your drive setup this might not be what you want. There is a setting accessible through the command line tool [VBoxManage][vboxmanage] that controls this location

    VBoxManage list systemproperties | grep "Default machine folder"

You can easily set it to a different location. The folder you point it to must already exist.

    VBoxManage setproperty machinefolder /mnt/disk/vms

This will make VirtualBox and thus Vagrant create all new VMs as subfolders of `/mnt/disk/vms`

### Vagrant

Vagrant has in a short time become an important tool for a lot of different organizations. It has given us an unique ability to document and test _infrastructure as code_-setups in an easy, repeatable, sharable and cross-platfrom way. Other tools might be similiar but none checks all the same boxes.

Point your browser at [www.vagrantup.com][vagrant] to get the latest installation package and install it. For now there is sadly no automatic way to update Vagrant. If you have an old version of Vagrant 1.0.x installed via RubyGems, please remove it prior to installing.

## Vagrant up and running

Vagrant uses base images - templates - as its source for quickly bringing up a new virtual machine. These base images are called _boxes_ in Vagrant. A box is added to Vagrant with `vagrant box add`. Open a command line and add the box we are going to use

    vagrant box add centos6 http://bit.ly/143OOqN

This might take a while to finish, the box is just shy of 500mb to download. While waiting for it to complete you could skim through the [getting started guide][vagrant-guide] - obviously skipping the commands - just to get a feel of what you are doing.

After the add-command has completed we're ready to go. All VMs controlled by Vagrant must first be defined in a `Vagrantfile` so that will be the very first file of our project. Create an empty folder somewhere convenient for you to find, best place would probably be where you normally keep code or documents. Then initialize a Vagrantfile using the box name we defined above.

    mkdir ~/code/myproject
    cd ~/code/myproject
    vagrant init centos6

This creates a `Vagrantfile` with the bare minimum settings needed. To run your newly defined VM do

    vagrant up

Next, ssh into it and play around a bit.

    vagrant ssh

The `vagrant` user you will be logged in as has sudo rights so you are free to play around. As is common with Vagrant boxes Puppet (and even Chef) comes preinstalled, we will make use of this next. Another thing to notice, the `/vagrant` folder inside the VM is actually a mounted network share of your project folder. This makes it easy to edit files using tools on your host computer while they are _shared inside the VM_, part of what makes Vagrant so flexible.

## The $EDITOR checklist

If you already have a text editor of choice it would be most effective to just use that for Puppet. Puppet is a simple language and an integrated syntax checker isn't strictly needed. Some even do without syntax coloring, but that I wouldn't recommmend. I have a short bullet list of points regarding editor setup which is based on my own experience and the [Puppet style guide][puppet-style]

* The Puppet community prefers two spaces, no tabs
* Syntax coloring is helpful, consider using it
* Integration with git (e.g diff) saves time
* You could try [Geppetto], an Eclipse-based Puppet IDE

The main thing to get across here is that most any editor you are comfortable with will do. Its OK if it only lets you enter text, there are external tools that will cover all the other bases.

[cli-thw]:        http://cli.learncodethehardway.org/
[git]:            http://git-scm.com/
[progit]:         http://git-scm.com/book
[progit-install]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[progit-setup]:   http://git-scm.com/book/en/Getting-Started-First-Time-Git-Setup
[virtualbox-dl]:  https://www.virtualbox.org/wiki/Downloads
[vboxmanage]:     https://www.virtualbox.org/manual/ch08.html
[vagrant]:        http://www.vagrantup.com/
[vagrant-guide]:  http://docs.vagrantup.com/v2/getting-started/index.html
[puppet-style]:   http://docs.puppetlabs.com/guides/style_guide.html
[geppetto]:       http://cloudsmith.github.io/geppetto/
