# @api private
#
# This class is meant to be called from samba to manage the samba service.
#
class samba::service {

  service { $::samba::service_name:
    ensure     => $::samba::service_ensure,
    enable     => $::samba::service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
