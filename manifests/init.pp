# @summary Manage fail2ban
#
# @example Manage fail2ban and add sshd jail
#   class { 'fail2ban':
#     jails => ['sshd'],
#   }
#
# @param ensure
#   Determines presence of fail2ban.
# @param package_ensure
#   The ensure property of fail2ban package.
# @param package_name
#   The fail2ban package name.
# @param manage_repo
#   Boolean that sets if fail2ban repo is managed.
#   For EL systems this enables management of EPEL repo.
# @param service_name
#   fail2ban service name.
# @param service_ensure
#   fail2ban service ensure property.
# @param service_enable
#   fail2ban service enable property.
# @param service_hasstatus
#   fail2ban service hasstatus property.
# @param service_hasrestart
#   fail2ban service hasrestart property.
# @param config_path
#   Path to fail2ban.local.
# @param jail_config_path
#   Path to jail.local.
# @param default_ignoreip
#   Global ignoreip value.
# @param default_bantime
#   Global bantime value.
# @param default_findtime
#   Global findtime value.
# @param default_maxretry
#   Global maxretry value. 
# @param logtarget
#   Location of logtarget.
# @param jails
#   Array or Hash of jails. Value is passed to `fail2ban::jail` defined type.
#
class fail2ban (
  Enum['present', 'absent'] $ensure       = 'present',
  String $package_ensure                  = 'present',
  String $package_name                    = 'fail2ban-server',
  Boolean $manage_repo                    = true,
  String $service_name                    = 'fail2ban',
  String $service_ensure                  = 'running',
  Boolean $service_enable                 = true,
  Boolean $service_hasstatus              = true,
  Boolean $service_hasrestart             = true,
  Stdlib::Absolutepath $config_path       = '/etc/fail2ban/fail2ban.local',
  Stdlib::Absolutepath $jail_config_path  = '/etc/fail2ban/jail.local',
  Array[String] $default_ignoreip         = ['127.0.0.1/8'],
  Integer $default_bantime                = 600,
  Integer $default_findtime               = 600,
  Integer $default_maxretry               = 5,
  Variant[Enum['SYSLOG','STDOUT','STDERR'],Stdlib::Absolutepath]
    $logtarget                            = '/var/log/fail2ban.log',
  Optional[Variant[Array, Hash]] $jails   = undef,
) {

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

  contain fail2ban::install
  contain fail2ban::config
  contain fail2ban::service

  if $ensure == 'present' {
    Class['fail2ban::install']
    -> Class['fail2ban::config']
    ~> Class['fail2ban::service']
  } else {
    Class['fail2ban::service']
    -> Class['fail2ban::config']
    -> Class['fail2ban::install']
  }


  if $jails and $ensure == 'present' {
    if $jails =~ Array {
      fail2ban::jail { $jails: }
    } elsif $jails =~ Hash {
      create_resources('fail2ban::jail', $jails)
    }
  }

}
