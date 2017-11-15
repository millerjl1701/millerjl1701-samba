# @api private
#
# This class is meant to be called from samba to manage smb and nmb services
#
class samba::service {
  assert_private('samba::service is a private class')

  service { $::samba::service_nmb_name:
    ensure     => $::samba::service_nmb_ensure,
    enable     => $::samba::service_nmb_enable,
    hasstatus  => true,
    hasrestart => true,
  }
  service { $::samba::service_smb_name:
    ensure     => $::samba::service_smb_ensure,
    enable     => $::samba::service_smb_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
