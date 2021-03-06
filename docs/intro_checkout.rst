Checking out the project
========================

Having installed the requirements we're now ready to check out and
browse around the project to look at how it is structured.

Cloning from GitHub
-------------------

Since this is a public project we keep a copy of its source on GitHub.
This is not the only copy or even an authorative one but we will keep it
updated to reflect the current status of the project.

::

    git clone https://github.com/norcams/winch

This will make a full clone of the source repository and store it on
your local computer.

Committing changes to GitHub
----------------------------

When a change is made to the repository on your local computer it is time to 
commit the change to GitHub. This is done in three steps: 

::

    git add docs/intro_checkout.rst
    git commit -m "Added some more documentation"
    git push



::

    git pull

Always perform a git pull command to check for updates in the repository. Files
may have changed since the last time you checked out the repository.     

Checking out other branches
---------------------------

There are several branches under winch. To keep track on which branch
you're currently working on, the git branch command is useful.

::

    git branch -a
    * master
    remotes/origin/HEAD -> origin/master
    remotes/origin/ceph
    remotes/origin/foreman
    remotes/origin/master
    remotes/origin/workshop

To check out another branch. Use the following command:

::

    git checkout foreman
    

Project folder structure
------------------------

::

    .
    ├── Vagrantfile
    ├── docs
    ├── puppet
    │   ├── hieradata
    │   ├── manifests
    │   ├── modules
    │   └── site
    ├── tests
    └── vagrant


Vagrantfile
~~~~~~~~~~~

Winch uses a fairly advanced Vagrantfile that loads configuration for
multiple VMs. To be able to quickly change VM settings have a look 
at the nodes.yaml file inside the vagrant folder. Here we've specified
several node settings for different VMs, like CPU, memory, networks and so
on. Winch consists of several nodes that makes up the different OpenStack components,
currently these are manager, controller and compute.

Inside the Vagrantfile there are several provision scripts that gets
executed when starting either one of these nodes. Note that some of these scripts
only gets executed on specific nodes. For example:

::

     box.vm.provision :shell, :path => "vagrant/install-puppetlabsrepo.sh"
     box.vm.provision :shell, :path => "vagrant/virbr0-fix.sh"
     
     # The following scripts will be executed on node manager
     box.vm.provision :shell, :path => "vagrant/manager-persistent-config.sh"
     box.vm.provision :shell, :path => "vagrant/foreman.sh"
    
docs
~~~~
This documentation.

puppet
~~~~~~

This is where the OpenStack puppet modules are found.
We are currently using puppet modules made by a group called stackforge. Their repository
can be found at https://github.com/stackforge/puppet-openstack. Winch currently supports
the OpenStack Icehouse release, but will be updated to Juno as soon as the puppet modules have been
updated to support this version.

tests
~~~~~~~
This folder contains a series of testscripts. When executed chronologically the system will have done everything from importing an image to launching an instance with external connectivity. These tests have been made to verify OpenStack functionality and to ensure that all components of the system is working as intended. If an error should occur during one of the tests, it is much easier to retrace your steps to find out exactly where it went wrong.

vagrant
~~~~~~~
Storage location for all the provision scripts used in the Vagrantfile. There are also some create scripts which will be explained later.