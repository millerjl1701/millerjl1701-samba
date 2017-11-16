# Class: samba
# ===========================
#
# Main class that includes all other classes for the samba module.
#
# @param config_dir Specifies the configuration directory.
# @param config_file Specifies the name of the configuraiton file.
# @param global_config Hash containing the global/special section configuration parameters.
# @param global_config_template Specifies the template to use for the samba global/special sections.
# @param package_ensure Whether to install the samba package, and/or what version. Values: 'present', 'latest', or a specific version number.
# @param package_name Specifies the name of the package to install.
# @param service_nmb_enable Whether to enable the nmb service at boot.
# @param service_nmb_ensure Whether the nmb service should be running.
# @param service_nmb_name Specifies the name of the service to manage.
# @param service_smb_enable Whether to enable the smb service at boot.
# @param service_smb_ensure Whether the smb service should be running.
# @param service_smb_name Specifies the name of the service to manage.
# @param shares_definitions Hash containing the shares to be created.
# @param shares_template Specifies the template to use to construct the shares concat fragment.
#
class samba (
  Stdlib::Absolutepath       $config_dir             = '/etc/samba',
  String                     $config_file            = 'smb.conf',
  Hash                       $global_config          = {},
  String                     $global_config_template = 'samba/global.erb',
  String                     $package_ensure         = 'present',
  String                     $package_name           = 'samba',
  Boolean                    $service_nmb_enable     = false,
  Enum['running', 'stopped'] $service_nmb_ensure     = 'stopped',
  String                     $service_nmb_name       = 'nmb',
  Boolean                    $service_smb_enable     = true,
  Enum['running', 'stopped'] $service_smb_ensure     = 'running',
  String                     $service_smb_name       = 'smb',
  Hash                       $shares_definitions     = {},
  String                     $shares_template        = 'samba/shares.erb',
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
