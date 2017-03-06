# See README.md for more details.
class fail2ban (
  $ensure               = 'present',
  $package_ensure       = 'present',
  $package_name         = $fail2ban::params::package_name,
  $manage_repo          = true,
  $service_name         = $fail2ban::params::service_name,
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_hasstatus    = $fail2ban::params::service_hasstatus,
  $service_hasrestart   = $fail2ban::params::service_hasrestart,
  $config_path          = $fail2ban::params::config_path,
  $jail_config_path     = $fail2ban::params::jail_config_path,
  $default_ignoreip     = ['127.0.0.1/8'],
  $default_bantime      = '600',
  $default_findtime     = '600',
  $default_maxretry     = '5',
  $logtarget            = $fail2ban::params::logtarget,
  $jails                = undef,
) inherits fail2ban::params {

  validate_bool($manage_repo)

  case $ensure {
    'present': {
      $_package_ensure = $package_ensure
      $_service_ensure = $service_ensure
      $_config_ensure  = 'file'
      $_service_enable = $service_enable
    }
    'absent': {
      $_package_ensure = 'absent'
      $_service_ensure = 'stopped'
      $_config_ensure  = 'absent'
      $_service_enable = false
    }
  }

  include fail2ban::install
  include fail2ban::config
  include fail2ban::service

  if $ensure == 'present' {
    anchor { 'fail2ban::start': }->
    Class['fail2ban::install']->
    Class['fail2ban::config']~>
    Class['fail2ban::service']->
    anchor { 'fail2ban::end': }
  } else {
    anchor { 'fail2ban::start': }->
    Class['fail2ban::service']->
    Class['fail2ban::config']->
    Class['fail2ban::install']->
    anchor { 'fail2ban::end': }
  }


  if $jails and $ensure == 'present' {
    if is_array($jails) {
      fail2ban::jail { $jails: }
    } elsif is_hash($jails) {
      create_resources('fail2ban::jail', $jails)
    } else {
      $_type = type3x($jails)
      fail("Module ${module_name}: jails must be an array or a hash, ${_type} given.")
    }
  }

}
