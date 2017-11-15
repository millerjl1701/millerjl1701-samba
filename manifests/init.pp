# Class: samba
# ===========================
#
# Main class that includes all other classes for the samba module.
#
# @param package_ensure [String] Whether to install the samba package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name [String] Specifies the name of the package to install. Default value: 'samba'.
# @param service_enable [Boolean] Whether to enable the samba service at boot. Default value: true.
# @param service_ensure [Enum['running', 'stopped']] Whether the samba service should be running. Default value: 'running'.
# @param service_name [String] Specifies the name of the service to manage. Default value: 'samba'.
#
class samba (
  String                     $package_ensure = 'present',
  String                     $package_name   = 'samba',
  Boolean                    $service_enable = true,
  Enum['running', 'stopped'] $service_ensure = 'running',
  String                     $service_name   = 'samba',
  ) {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      contain samba::install
      contain samba::config
      contain samba::service

      Class['samba::install']
      -> Class['samba::config']
      ~> Class['samba::service']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
