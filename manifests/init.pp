# Class: samba
# ===========================
#
# Main class that includes all other classes for the samba module.
#
# @param package_ensure [String] Whether to install the samba package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name [String] Specifies the name of the package to install. Default value: 'samba'.
# @param service_nmb_enable [Boolean] Whether to enable the nmb service at boot. Default value: false.
# @param service_nmb_ensure [Enum['running', 'stopped']] Whether the nmb service should be running. Default value: 'stopped'.
# @param service_nmb_name [String] Specifies the name of the service to manage. Default value: 'nmb'.
# @param service_smb_enable [Boolean] Whether to enable the smb service at boot. Default value: true.
# @param service_smb_ensure [Enum['running', 'stopped']] Whether the smb service should be running. Default value: 'running'.
# @param service_smb_name [String] Specifies the name of the service to manage. Default value: 'smb'.
#
class samba (
  String                     $package_ensure = 'present',
  String                     $package_name   = 'samba',
  Boolean                    $service_nmb_enable = false,
  Enum['running', 'stopped'] $service_nmb_ensure = 'stopped',
  String                     $service_nmb_name   = 'nmb',
  Boolean                    $service_smb_enable = true,
  Enum['running', 'stopped'] $service_smb_ensure = 'running',
  String                     $service_smb_name   = 'smb',
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
