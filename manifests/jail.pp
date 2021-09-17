# @summary Manage jail configs
#
# @example
#   fail2ban::jail { 'sshd': ensure => 'present' }
#
# @param ensure
#   Sets if jail should be enabled or disabled
#
define fail2ban::jail (
  Enum['present', 'absent'] $ensure = 'present',
) {

  include fail2ban

  $_enabled = $ensure ? {
    'present' => true,
    'absent'  => false,
  }

  fail2ban_jail_config { "${name}/enabled": value => $_enabled, notify => Class['fail2ban::service'] }

}