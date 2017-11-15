# @api private
#
# This class is called from the main samba class for install.
#
class samba::install {
  package { $::samba::package_name:
    ensure => $::samba::package_ensure,
  }
}
