# Private class.
class fail2ban::params {

  case $::osfamily {
    'RedHat': {
      $package_name       = 'fail2ban'
      $service_name       = 'fail2ban'
      $service_hasstatus  = true
      $service_hasrestart = true
      $config_path        = '/etc/fail2ban/fail2ban.local'
      $jail_config_path   = '/etc/fail2ban/jail.local'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
