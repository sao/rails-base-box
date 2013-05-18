# A Virtual Machine for Ruby on Rails Development

## Introduction

This is a base box to use for Ruby on Rails Development. Inspired by fxn's [rails-dev-box](https://github.com/rails/rails-dev-box)

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

## How To Build The Virtual Machine

Building the virtual machine is this easy:

    host $ git clone https://github.com/sao/rails-base-box.git
    host $ cd rails-base-box
    host $ vagrant up
    host $ vagrant ssh
    Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)
    ...
    vagrant@rails-base-box:~$

Port 3000 in the host computer is forwarded to port 3000 in the virtual machine. Thus, applications running in the virtual machine can be accessed via localhost:3000 in the host computer.

## What's In The Box

* Git

* rbenv w/ rbenv-vars and ruby-build

* Ruby 2.0.0

* Bundler

* SQLite3 and Postgres

* System dependencies for nokogiri, sqlite3 and pg

* Databases and users

* Node.js for the asset pipeline

* Memcached

## Virtual Machine Management

When done just log out with `^D` and suspend the virtual machine

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # DANGER: all is gone

Please check the [Vagrant documentation](http://vagrantup.com/v1/docs/index.html) for more information on Vagrant.
