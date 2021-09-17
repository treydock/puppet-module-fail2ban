# Private class.
class fail2ban::config {
  assert_private()

  resources { 'fail2ban_config':
    purge => true,
  }

  resources { 'fail2ban_jail_config':
    purge => true,
  }

  file { '/etc/fail2ban/fail2ban.local':
    ensure => $fail2ban::_config_ensure,
    path   => $fail2ban::config_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/fail2ban/jail.local':
    ensure => $fail2ban::_config_ensure,
    path   => $fail2ban::jail_config_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  if $fail2ban::ensure == 'present' {
    fail2ban_config { 'Definition/logtarget': value => $fail2ban::logtarget }
    fail2ban_jail_config { 'DEFAULT/ignoreip': value => join($fail2ban::default_ignoreip, ' ') }
    fail2ban_jail_config { 'DEFAULT/bantime': value => $fail2ban::default_bantime }
    fail2ban_jail_config { 'DEFAULT/findtime': value => $fail2ban::default_findtime }
    fail2ban_jail_config { 'DEFAULT/maxretry': value => $fail2ban::default_maxretry }
  }

}
