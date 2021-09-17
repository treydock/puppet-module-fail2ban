# puppet-module-fail2ban

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/fail2ban.svg)](https://forge.puppetlabs.com/treydock/fail2ban)
[![Build Status](https://travis-ci.org/treydock/puppet-module-fail2ban.png)](https://travis-ci.org/treydock/puppet-module-fail2ban)

#### Table of Contents

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

[http://treydock.github.io/puppet-module-fail2ban/](http://treydock.github.io/puppet-module-fail2ban/)

## Limitations

This module has been tested on:

* CentOS/RedHat 7 x86_64
* CentOS/RedHat 8 x86_64

