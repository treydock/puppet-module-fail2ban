# See README.md for more details.
class fail2ban (
  Enum['present', 'absent'] $ensure       = 'present',
  String $package_ensure                  = 'present',
  String $package_name                    = $fail2ban::params::package_name,
  Boolean $manage_repo                    = true,
  String $service_name                    = $fail2ban::params::service_name,
  String $service_ensure                  = 'running',
  Boolean $service_enable                 = true,
  Boolean $service_hasstatus              = $fail2ban::params::service_hasstatus,
  Boolean $service_hasrestart             = $fail2ban::params::service_hasrestart,
  Stdlib::Absolutepath $config_path       = $fail2ban::params::config_path,
  Stdlib::Absolutepath $jail_config_path  = $fail2ban::params::jail_config_path,
  Array[Stdlib::Compat::Ip_address]
    $default_ignoreip                     = ['127.0.0.1/8'],
  Integer $default_bantime                = 600,
  Integer $default_findtime               = 600,
  Integer $default_maxretry               = 5,
  Variant[Enum['SYSLOG','STDOUT','STDERR'],Stdlib::Absolutepath]
    $logtarget                            = $fail2ban::params::logtarget,
  Optional[Variant[Array, Hash]] $jails   = undef,
) inherits fail2ban::params {

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
    default: {}
  }

  include fail2ban::install
  include fail2ban::config
  include fail2ban::service

  if $ensure == 'present' {
    anchor { 'fail2ban::start': }
    -> Class['fail2ban::install']
    -> Class['fail2ban::config']
    ~> Class['fail2ban::service']
    -> anchor { 'fail2ban::end': }
  } else {
    anchor { 'fail2ban::start': }
    -> Class['fail2ban::service']
    -> Class['fail2ban::config']
    -> Class['fail2ban::install']
    -> anchor { 'fail2ban::end': }
  }


  if $jails and $ensure == 'present' {
    if $jails =~ Array {
      fail2ban::jail { $jails: }
    } elsif $jails =~ Hash {
      create_resources('fail2ban::jail', $jails)
    }
  }

}
