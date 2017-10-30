# puppet-module-fail2ban

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/fail2ban.svg)](https://forge.puppetlabs.com/treydock/fail2ban)
[![Build Status](https://travis-ci.org/treydock/puppet-module-fail2ban.png)](https://travis-ci.org/treydock/puppet-module-fail2ban)

####Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

This module manages Fail2ban.

## Usage

### fail2ban

Install and configure fail2ban with SSH jail.

    class { 'fail2ban':
      jails => ['sshd'],
    }

Configure fail2ban to not ban a local subnet

    class { 'fail2ban':
      jails            => ['sshd'],
      default_ignoreip => ['10.0.0.0/8'],
    }

## Reference

### Classes

#### Public classes

* `fail2ban`: Installs and configures fail2ban.

#### Private classes

* `fail2ban::install`: Installs fail2ban packages.
* `fail2ban::config`: Configures fail2ban.
* `fail2ban::service`: Manages the fail2ban service.
* `fail2ban::params`: Sets parameter defaults based on fact values.

### Parameters

#### fail2ban

##### ensure

Determines presence of fail2ban. Valid values are `present` and `absent`, default is `present`.

##### package_ensure

The ensure property of fail2ban package. Default is `present`.

##### package_name

The fail2ban package name. Default is OS dependent.

##### manage_repo

Boolean that sets if fail2ban repo is managed. For EL systems this enables management of EPEL repo.  Default is `true`

##### service_name

fail2ban service name. Default is OS dependent.

##### service_ensure

fail2ban service ensure property. Default is `running`.

##### service_enable

fail2ban service enable property. Default is `true`.

##### service_hasstatus

fail2ban service hasstatus property. Default is OS dependent.

##### service_hasrestart

fail2ban service hasrestart property. Default is OS dependent.

##### config_path

Path to fail2ban.local. Default is OS dependent.

##### jail\_config_path

Path to jail.local. Default is OS dependent.

##### default_ignoreip

Global ignoreip value. Default is `['127.0.0.1/8']`

##### default_bantime

Global bantime value. Default is `600`.

##### default_findtime

Global findtime value. Default is `600`.

##### default_maxretry

Global maxretry value. Default is `5`

##### logtarget

Location of logtarget. Accepts `SYSLOG`, `STDOUT`, `STDERR` or a file path.  Default is `/var/log/fail2ban.log`.

##### jails

Array or Hash of jails. Value is passed to `fail2ban::jail` defined type. Default is `undef`.

## Limitations

This module has been tested on:

* CentOS/RedHat 6 x86_64
* CentOS/RedHat 7 x86_64

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## TODO

## Further Information

*
