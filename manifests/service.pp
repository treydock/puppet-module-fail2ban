# Private class.
class fail2ban::service {
  assert_private()

  service { 'fail2ban':
    ensure     => $fail2ban::_service_ensure,
    enable     => $fail2ban::_service_enable,
    name       => $fail2ban::service_name,
    hasstatus  => $fail2ban::service_hasstatus,
    hasrestart => $fail2ban::service_hasrestart,
  }

}
