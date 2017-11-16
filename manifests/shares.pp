# @api private
#
# This class creates concat fragment for shares for smb.conf
#
class samba::shares {
  assert_private('samba::shares is a private class')

  $definitions = $samba::shares_definitions

  if ! empty($definitions) {  
    concat::fragment { 'shares':
      target  => "${samba::config_dir}/${samba::config_file}",
      order   => 'shares',
      content => template($samba::shares_template),
    }
  }
}
