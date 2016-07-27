# puppet-module-fail2ban

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



## Usage

### fail2ban

    class { 'fail2ban': }

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

#####`foo`

## Limitations

This module has been tested on:

* CentOS 6 x86_64

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
