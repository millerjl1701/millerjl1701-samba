# @api private
#
# This class is called from the main samba class for install.
#
class samba::install {
  assert_private('samba::install is a private class')

  package { $::samba::package_name:
    ensure => $::samba::package_ensure,
  }
}
