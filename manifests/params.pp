# Private class.
class fail2ban::params {

  case $::osfamily {
    'RedHat': {
      $service_name       = 'fail2ban'
      $service_hasstatus  = true
      $service_hasrestart = true
      $config_path        = '/etc/fail2ban/fail2ban.local'
      $jail_config_path   = '/etc/fail2ban/jail.local'
      if versioncmp($::operatingsystemrelease, '7.0') >= 0 {
        $package_name       = 'fail2ban-server'
      } else {
        $package_name       = 'fail2ban'
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
