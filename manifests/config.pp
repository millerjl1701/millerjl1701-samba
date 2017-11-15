# @api private
#
# This class is called from samba for service config.
#
class samba::config {
  assert_private('samba::config is a private class')

  $config = $::samba::global_config

  concat { "${samba::config_dir}/${samba::config_file}":
    ensure => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => "${samba::config_dir}/${samba::config_file}",
  }

  concat::fragment { 'global':
    target  => "${samba::config_dir}/${samba::config_file}",
    order   => '0_global',
    content => template($samba::global_config_template),
  }
}
