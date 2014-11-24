Learning Winch
==============

WIP

Requirements
------------
- A local copy of the winch project from GitHub
- VirtualBox and vagrant installed on your computer
- Knowledge about the OpenStack components

There are two different ways to deploy OpenStack using the winch project:

1. Using vagrant 
----------------
Depending on your machine configuration vagrant allows you to have an OpenStack enviroment
up and running within a few minutes. If you are only just getting started with winch this
approach is the most useful. The provision process happens on screen allowing you to view every
step of the way from an empty box to a fully manageable OpenStack component. Once this approach is complete you should have installed one controller node, and one compute node.

Before spawning any virtual machines you need to be inside the winch folder. To check if any of the machines are already running, run vagrant status:

::

    manager         not created (virtualbox)
    controller      not created (virtualbox)
    compute         not created (virtualbox)

Spawn the controller node first, then continue with the compute node:

::

    vagrant up controller
    vagrant up compute

Vagrant will start provisioning the machines based on the vagrantfile which we explained
earlier. After the RPM packages and repositories have been installed the puppet modules will
be applied. If anything should go wrong either during installation or when applying the 
puppet modules it is possible to run the provisioning process again. A fault may occur one
out of ten times so this step is usually not necessary.

::

    vagrant provision controller

When the installation process is complete you will have a running OpenStack enviroment. 
The next step is to login with SSH and run the predefined tests to verify that the installation
is working as intended. 

::

    vagrant ssh controller

Become root and navigate to /vagrant/tests. All the tests needs to be executed with an OpenStack user.
Source the 00-testuser.sh file and execute all tests in chronological order.

::

    source 00-testuser.sh
    sh 01-import_image.sh...
    
When complete you will have an instance running in your newly created OpenStack cloud! To setup
more networks, routers and instances be sure to checkout the Horizon dashboard. Currently this 
is running on http://192.168.11.12/dashboard. Use the credentials in 00-testuser.sh.

If you're deploying OpenStack for the very first time chances are you'll make mistakes as
you go along. This is why vagrant is useful. If you do any serious damage or flip to many
switches along the way simply destroy the machines and start over.

::

    vagrant destroy controller compute
    Are you sure you want to destroy the 'controller' VM? [y/N] y
    Are you sure you want to destroy the 'compute' VM? [y/N] y

2. Using Foreman
----------------

