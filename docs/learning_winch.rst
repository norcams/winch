Learning Winch
==============

WIP


There are two different ways to deploy OpenStack using the winch project:

1. Using vagrant 
----------------
Depending on your machine configuration vagrant allows you to have an OpenStack enviroment
up and running within a few minutes. If you are only just getting started with winch this
approach is the most useful. The provision process happens on screen allowing you to view every
step of the way from an empty box to a fully manageable OpenStack component.

Once this approach is complete you should have installed one controller node, and one compute node.

Requirements
------------
- A local copy of the winch project from GitHub
- VirtualBox and vagrant installed on your computer

Before spawning any virtual machines you need to be inside the winch folder. To check if any of the machines are already running, run vagrant status:

::

    manager         not created (virtualbox)
    controller      not created (virtualbox)
    compute         not created (virtualbox)

To spawn the controller node simply type:

::

    vagrant up controller

Vagrant will start provisioning the machine based on the vagrantfile which we explained
earlier. After the RPM packages and repositories have been updated the puppet modules will
be applied. If anything should go wrong either during installation or when applying the 
puppet modules it is possible to run the provisioning process again. A fault may occur one
out of ten times so this step is usually not necessary.

::

    vagrant provision controller

To spawn the compute node repeat the same process as before, by replacing controller with compute.

::

    vagrant up compute

When the installation process is complete you will have a running OpenStack enviroment. 
The next step is to login with SSH and run the predefined tests to verify that the installation
is working as intended. 

::

    vagrant ssh controller










If you're deploing OpenStack for the very first time chances are you'll make mistakes as
you go along.



2. Using Foreman
----------------

