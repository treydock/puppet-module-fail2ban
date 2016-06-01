# Private class.
class fail2ban::config {

  file { '/etc/fail2ban/fail2ban.local':
    ensure => 'file',
    path   => $fail2ban::config_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/fail2ban/jail.local':
    ensure => 'file',
    path   => $fail2ban::jail_config_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  fail2ban_jail_config { 'DEFAULT/ignoreip': value => join($fail2ban::default_ignoreip, ' ') }
  fail2ban_jail_config { 'DEFAULT/bantime': value => $fail2ban::default_bantime }
  fail2ban_jail_config { 'DEFAULT/findtime': value => $fail2ban::default_findtime }
  fail2ban_jail_config { 'DEFAULT/maxretry': value => $fail2ban::default_maxretry }

}
