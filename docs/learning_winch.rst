Learning Winch
==============

WIP

Requirements
------------
- A local copy of the winch project from GitHub
- VirtualBox and vagrant installed on your computer
- Knowledge about the OpenStack components and IP forwarding

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
Run the 00-testuser.sh script to create the a keystone file for authentication. Source this file in order to run the rest of the testscripts. 
::

    source /root/keystonerc_admin
    sh 01-import_image.sh...
    
When complete you will have an instance running in your newly created OpenStack cloud! To setup
more networks, routers and instances be sure to checkout the Horizon dashboard. Currently this 
is running on http://192.168.11.12/dashboard. Use the credentials in the kyestone file. In order 
to get instances in your cloud to talk to the outside world, IP forwarding needs to be enabled on
your host machine. 

If you're deploying OpenStack for the very first time chances are you'll make mistakes as
you go along. This is why vagrant is useful. If you do any serious damage or flip to many
switches along the way simply destroy the machines and start over.

::

    vagrant destroy controller compute
    Are you sure you want to destroy the 'controller' VM? [y/N] y
    Are you sure you want to destroy the 'compute' VM? [y/N] y

**Summary**

After deploying OpenStack with vagrant your setup should consist of the following:

- A controller node
- A compute node
- One test instance running Cirros with external connectivity
- 3 users that can login to the Horizon dashboard
- Testsubnet and a testruter
 

2. Using Foreman
----------------

The second way to install OpenStack within the winch project is to use Forman. This approach takes
a little while longer than vagrant, mainly because Foreman installs the controller and the compute
nodes from scratch. 

Instead of running around with a CD to install your production enviroment Foreman
is all about making manual repetitive tasks automated. Foreman can install an operating system on bare-metal automatically allowing the administrator to configure every step of the process. In winch Foreman runs on a separated machine called manager. Provisioning this machine is the very first step in this
approach.

::

    vagrant up manager
    
    
Provision of this machine takes a little while. This is because the provision script inside the vagrant folder does everything from fetching the repository to the installation and configuration of Foreman. It is recommended to have a look at the different installation scripts to get a feel on whats going on. The foreman.sh script consists of the following:

::

    foreman_puppet.sh
    foreman_add_repo.sh
    foreman_install.sh
    foreman_puppetmaster-config.sh
    foreman_configure.sh
    foreman_netfwd.sh

::


    Foreman is running at https://manager.winch.local
      Initial credentials are admin / changeme


Use the default credentials to checkout the Foreman webpanel after the installation. Foreman should now 
consist of two host groups and puppet modules for each of the components. The host groups specify different
settings for each component and allows scalability if more nodes are added to the installation at a later point. To
create the controller and compute node run the create scripts inside the vagrant folder:

::

    sh create-vbox-controller.sh
    sh create-vbox-compute

These scripts will create two empty machines in VirtualBox and register them in Foreman with the appropriate settings. This step
is absolutely necessary to get the machines automatically installed. Start with installing the controller node before moving onto
the compute node. Launch the virtual machine and make sure F12 is pressed during post, then continue with booting from PXE. The machine
will boot up and Foreman will install the machine automatically.Once the machine is complete it will start to run the puppet modules. 
During this process it's probably a good idea to tail the syslog to see if everything works as intended. When the puppet apply is finished, 
continue with installing the compute node.

After both machines have been installed, log on and run the OpenStack tests to verify functionality and to make sure all parts of the system is 
working as intended. Note that forwarding traffic from instances and to the outside world is a bit more tricky than in the previous section. One way to
go about this is to give an IP address to the brex interface on the controller and connecting the interface to a bridge. Then your host machine need IP forwarding
enabled in order to push traffic back and forth to the instances in your cloud.


**Summary**

After deploying OpenStack with Foreman your setup should be much more scalable consisting of:

- A manager node running Foreman (consisting of one puppetmaster & host groups for each component)
- A controller node built with Foreman
- A compute node built with Foreman
- One test instance running Cirros with external connectivity
- 3 users that can login to the Horizon dashboard
- Testsubnet and a testruter
