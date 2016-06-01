#
define fail2ban::jail (
  $ensure = 'present',
) {

  include fail2ban

  case $ensure {
    'present': {
      $_enabled = true
    }
    'absent': {
      $_enabled = false
    }
    default: {
      fail("Defined type fail2ban::jail: ensure only supports 'present' or 'absent', ${ensure} given.")
    }
  }

  fail2ban_jail_config { "${name}/enabled": value => $_enabled }

}