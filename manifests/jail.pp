#
define fail2ban::jail (
  Enum['present', 'absent'] $ensure = 'present',
) {

  include fail2ban

  $_enabled = $ensure ? {
    'present' => true,
    'absent'  => false,
  }

  fail2ban_jail_config { "${name}/enabled": value => $_enabled }

}