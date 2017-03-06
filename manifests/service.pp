# Private class.
class fail2ban::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'fail2ban':
    ensure     => $fail2ban::_service_ensure,
    enable     => $fail2ban::_service_enable,
    name       => $fail2ban::service_name,
    hasstatus  => $fail2ban::service_hasstatus,
    hasrestart => $fail2ban::service_hasrestart,
  }

}
