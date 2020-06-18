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
1. [Credits](#credits)

## Module Description

This module installs, configures, and manages samba without the use of opinionated templates or sets of parameters.

For more details on Samba and the capabilities it provides, please see: [https://www.samba.org/](https://www.samba.org/)

This module provides puppet data in module as well as uses the Puppet 4 type classes. It will not work on older versions of Puppet. It seems to work on Puppet 5 so far.

This module is currently written to support samba on CentOS/RedHat 6/7 operating systems. Other operating system support could be added if time permits (Pull requests are welcome. :)

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

All parameters to the main classc an be passed via puppet code or hiera.

Note: the Puppet lookup function will by default create a merged hash from hiera data for the samba::shares_definitions parameter. It would be possible to override the merge behavior in your own hiera data; however, this has not been tested and could create unexpected results.

Some examples are presented below with the file that is output from the code.

### Creating the default CentOS 7 smb.conf file via hiera (less all the commented out parameters and comments)

```yaml
samba::global_config:
  'global':
    'workgroup': 'SAMBA'
    'security': 'user'
    'passdb backend': 'tdbsam'
    'printing': 'cups'
    'printcap name': 'cups'
    'load printers': 'yes'
    'cups options': 'raw'
  'homes':
    'comment': 'Home Directories'
    'valid users': '%S, %D%w%S'
    'browseable': 'No'
    'read only': 'No'
    'inherit acls': 'Yes'
  'printers':
    'comment': 'All Printers'
    'path': '/var/tmp'
    'printable': 'Yes'
    'create mask': '0600'
    'browseable': 'No'
  'print$':
    'comment': 'Printer Drivers'
    'path': '/var/lib/samba/drivers'
    'write list': 'root'
    'create mask': '0664'
    'directory mask': '0775'
```

and the resulting configuration file:

```bash
# Managed by Puppet.

[global]
        workgroup = SAMBA
        security = user
        passdb backend = tdbsam
        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw

[homes]
        comment = Home Directories
        valid users = %S, %D%w%S
        browseable = No
        read only = No
        inherit acls = Yes

[printers]
        comment = All Printers
        path = /var/tmp
        printable = Yes
        create mask = 0600
        browseable = No

[print$]
        comment = Printer Drivers
        path = /var/lib/samba/drivers
        write list = root
        create mask = 0664
        directory mask = 077
```

### Adding comments to the global and special sections

```yaml
samba::global_config:
  'global':
    'load printers': 'yes'
    'cups options': 'raw'
    '#comment1': 'Here is the end of the global section... moving on.'
```

results in smb.conf:

```bash
[global]
        load printers = yes
        cups options = raw
# Here is the end of the global section... moving on.
```

How it works: The template checks for a parameter that begins with the '#' character, and then uses the specified value as the actual comment. If you have multiple comment lines, each parameter needs to start with a '#' character and the rest of the characters need to be unique for that comment to prevent an error.

### Adding white space between options

```yaml
samba::global_config:
  'global':
    'workgroup': 'SAMBA'
    '__blank1': ''
    'security': 'user'
    'passdb backend': 'tdbsam'
    '__blank2': ''
    'printing': 'cups'
```

results in:

```bash
[global]
        workgroup = SAMBA

        security = user
        passdb backend = tdbsam

        printing = cups
```

How it works: The template checks for a parameter that begins with two `_` characters, and then just inserts a blank line into the resulting file. If you place multiple blank lines into a file, each parameter must begin with two `_` characters and be different from the others in the rest of the characters to prevent an error. The string value is ignored.

### Creating commented configuration items in the global and special sections

```yaml
samba::global_config:
  'global':
    'workgroup': 'SAMBA'
    'security': 'user'
    ';passdb backend': 'tdbsam'
```

results is:

```bash
[global]
        workgroup = SAMBA
        security = user
;       passdb backend = tdbsam
```

How it works: The template checks for a parameter that begins with a ';' character, and then starts the line with a ';' character, tabs and places the rest of characters (less the ';') followed by an equal sign, and then parses the string or array for the values of the parameter.

### Specifying multiple settings for an global or special section option

```yaml
samba::global_config:
  'global':
    'interfaces':
      - 'lo'
      - 'eth0'
    'bind interfaces only': 'yes'
```

results in:

```bash
[global]
        interfaces = lo eth0
        bind interfaces only = yes
```

### Specifying multiple settings for a share option

```yaml
samba::shares_definitions:
  'admin':
    'comment': 'Admin Stuff'
    'path': '/mnt/stuff'
    'valid users':
      - 'bar'
      - 'bob'
      - '@foo'
```

results in:

```bash
[admin]
       comment = Admin Stuff
       path = /mnt/stuff
       valid users = bar, bob, @foo
```

### Creating multiple shares using hiera

```yaml
samba::shares_definitions:
  'admin':
    'comment': 'Admin Stuff'
    'path': '/mnt/stuff'
    'valid users': 'bar, bob, @foo'
    'writable': 'yes'
  'public':
    'comment': 'Public Stuff'
    'path': '/mnt/public'
    'writable': 'no'
```

results in:

```bash
[admin]
       comment = Admin Stuff
       path = /mnt/stuff
       valid users = bar, bob, @foo
       writable = yes
[public]
       comment = Public Stuff
       path = /mnt/public
       writable = no
```

### Creating the same multiple shares as the previous example using puppet code

```puppet
class { 'samba':
  shares_definitions => {
    'admin' => {
      'comment'     => 'Admin Stuff',
      'path'        => '/mnt/stuff',
      'valid users' => [ 'bar', 'bob', '@foo', ],
      'writable'    => 'yes',
    },
    'public' => {
      'comment'  => 'Public Stuff',
      'path'     => '/mnt/stuff',
      'writable' => 'no',
    },
  }
}
```

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

There are many good modules to manage samba and winbind already; however, to me it seems they try to do too much. The design philosophy of this module is to keep things as simple as possible while being functional. If you need more added functionality that they provide, by all means do so.

### Contributors

To see who is involved with this module, see the [GitHub list of contributors](https://github.com/millerjl1701/millerjl1701-samba/graphs/contributors) or the [CONTRIBUTORS document](CONTRIBUTORS).

## Credits

This module was inspired from the excellent design work of the [sgnl05/sgnl05-sssd](https://github.com/sgnl05/sgnl05-sssd) puppet module. I loved how I could use it to specify a configuration file at will without having to wrangle parameterized classes for management of sssd. As that modules does, I used the sssd.conf template from [walkamongus/sssd](https://github.com/walkamongus/sssd) to generate concat fragments which then are assembled into the final samba configuration file.

