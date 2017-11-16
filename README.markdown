# samba

master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-samba.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-samba)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with samba](#setup)
    * [What samba affects](#what-samba-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with samba](#beginning-with-samba)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
    * [Contributors](#contributors)
1. [Credits](#credits)

## Module Description

This module installs, configures, and manages samba without the use of opinionated templates or sets of parameters.

For more details on Samba and the capabilities it provides, please see: [https://www.samba.org/](https://www.samba.org/)

There are many good modules to manage samba and winbind already; however, to me it seems they try to do too much. All I needed was to manage the package, config file, and service by driving the data via hiera. This is not to say that the other samba modules are not useful. They are. If you need more added functionality that they provide, by all means do so.

This module is currently written to support samba on CentOS/RedHat 6/7 operating systems. Other operating system support will be added as time permits (Pull requests are welcome. :)

## Setup

### What samba affects

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
* Package(s): samba
* File: /etc/samba/smb.conf
* Service(s): smb, nmb

### Setup Requirements

This module just configures samba. If you need to configure krb5.conf as a prerequite for samba (allowing for sssd for instance), may I suggest one of the following modules:

* [https://forge.puppet.com/ccin2p3/mit_krb5](https://forge.puppet.com/ccin2p3/mit_krb5)
* [https://forge.puppet.com/pfmooney/mit_krb5](https://forge.puppet.com/pfmooney/mit_krb5)
* [https://forge.puppet.com/simp/krb5](https://forge.puppet.com/simp/krb5)

Speaking of, if you are trying to configure sssd for use with samba, may I suggest one of the following modules:

* [https://forge.puppet.com/sgnl05/sssd](https://forge.puppet.com/sgnl05/sssd
* [https://forge.puppet.com/walkamongus/sssd](https://forge.puppet.com/walkamongus/sssd)
* [https://forge.puppet.com/simp/sssd](https://forge.puppet.com/simp/sssd)
* [https://forge.puppet.com/bodgit/sssd](https://forge.puppet.com/bodgit/sssd)

### Beginning with samba

`include samba` should be all that is needed to install, configure, and start the smb service using the parameters specified by the default smb.conf of the package install.

This module depends on the [puppetlabs/stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) and [puppetlabs/concat](https://github.com/puppetlabs/puppetlabs-concat) modules.

## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here.

## Reference

Generated puppet strings documentation with examples is available from [https://millerjl1701.github.io/millerjl1701-samba/](https://millerjl1701.github.io/millerjl1701-samba)

The puppet strings documentation is also included in the /docs folder.

### Public Classes

* samba: Main class which installs, configures, and manages the smb and nmb services.

### Private Classes

* samba::install: Class for installation of the samba package.
* samba::config: Class for construction of the /etc/samba/smb.conf configuration file.
* samba::service: Class for managing the state of the smb and nmb services.

## Limitations

This module was setup using CentOS 6 and 7 installation and documentation for rules. In time, other operating systems will be added as they have been tested. Pull requests with tests are welcome!

No validation or testing of the resulting /etc/samba/smb.conf file is done. This is left as an exercise for the reader.

## Development

Please see the [CONTRIBUTING document](CONTRIBUTING.md) for information on how to get started developing code and submit a pull request for this module. While written in an opinionated fashion at the start, over time this can become less and less the case.

### Contributors

To see who is involved with this module, see the [GitHub list of contributors](https://github.com/millerjl1701/millerjl1701-samba/graphs/contributors) or the [CONTRIBUTORS document](CONTRIBUTORS).

## Credits

This module was inspired from the excellent design work of the [sgnl05/sgnl05-sssd](https://github.com/sgnl05/sgnl05-sssd) puppet module. I loved how I could use it to specify a configuration file at will without having to wrangle parameterized classes for management of sssd. As that modules does, I used the sssd.conf template from [walkamongus/sssd](https://github.com/walkamongus/sssd) to generate concat fragments which then are assembled into the final samba configuration file.