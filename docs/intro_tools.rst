Tools of the trade
==================

This explanins how to set up a computer with git, VirtualBox and Vagrant
so that it is possible to use it for development.

Requirements
------------

There are some requirements before starting out.

-  Basic knowledge of `git <http://git-scm.com/>`_ and `command line
   tools <http://cli.learncodethehardway.org/>`_
-  A multi-core desktop or laptop computer running Linux or OSX with at
   least 4gb of RAM
-  A SSD drive for storing virtual machines

If you are missing some of these things might still work but possibly be
less enjoyable. Most importantly, use your fastest hardware! Running
virtual machines on a five year old laptop may seem acceptable at first
but really isn't. You *will* grow tired of waiting for reboots and
configuration runs to complete.

Using Windows as the host OS might be possible but is currently
untested.

Install the software stack
--------------------------

The software stack we need on the host computer consists of three main
components. You might have some of these installed already.

git
~~~

We are going to use git as our version control system. The `Pro Git
book <http://git-scm.com/book>`_ by Scott Chacon is an excellent go-to
reference, please use that to get
`installation <http://git-scm.com/book/en/Getting-Started-Installing-Git>`_
and `first-time
setup <http://git-scm.com/book/en/Getting-Started-First-Time-Git-Setup>`_
done.

VirtualBox
~~~~~~~~~~

VirtualBox will be our back-end virtualization engine for Vagrant. The
Vagrant ecosystem is currently fast-moving so make sure to get the
latest and greatest version directly from the *Downloads* page on
`www.virutalbox.org <https://www.virtualbox.org/wiki/Downloads>`_.

The installation instructions for Linux includes steps to add the
VirtualBox package repo to your package manager. This makes updating
easier or even automatic in the future so I recommend that you do so.

By default VirtualBox will create all virtual machines in a folder named
``VirtualBox VMs`` in your home folder. Depending on your drive setup
this might not be what you want. There is a setting accessible through
the command line tool
`VBoxManage <https://www.virtualbox.org/manual/ch08.html>`_ that
controls this location

::

    VBoxManage list systemproperties | grep "Default machine folder"

You can easily set it to a different location. The folder you point it
to must already exist.

::

    VBoxManage setproperty machinefolder /mnt/disk/vms

This will make VirtualBox and thus Vagrant create all new VMs as
subfolders of ``/mnt/disk/vms``

Vagrant
~~~~~~~

Vagrant has in a short time become an important tool for a lot of
different organizations. It has given us an unique ability to document
and test *infrastructure as code*-setups in an easy, repeatable,
sharable and cross-platfrom way. Other tools might be similiar but none
checks all the same boxes.

Point your browser at `www.vagrantup.com <http://www.vagrantup.com/>`_
to get the latest installation package and install it. For now there is
sadly no automatic way to update Vagrant. If you have an old version of
Vagrant 1.0.x installed via RubyGems, please remove it prior to
installing.

The $EDITOR checklist
---------------------

If you already have a text editor of choice it would be most effective
to just use that. Puppet is a simple language and an integrated syntax
checker isn't strictly needed. Some even do without syntax coloring, but
that I wouldn't recommmend. I have a short bullet list of points
regarding editor setup which is based on my own experience and the
`Puppet style
guide <http://docs.puppetlabs.com/guides/style_guide.html>`_

-  The Puppet community prefers two spaces, no tabs
-  Syntax coloring is helpful, consider using it
-  Integration with git (e.g diff) saves time
-  You could try
   `Geppetto <http://puppetlabs.github.io/geppetto/download.html>`_, an
   Eclipse-based Puppet IDE

The main thing to get across here is that most any editor you are
comfortable with will do. Its OK if it only lets you enter text, there
are external tools that will cover all the other bases.
