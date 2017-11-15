node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'samba':
    require => Notify['enduser-before'],
    before  => Notify['enduser-after'],
  }

}
