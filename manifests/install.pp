# Private class.
class fail2ban::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $fail2ban::manage_repo {
    if $::osfamily == 'RedHat' {
      include ::epel
      $_require = Class['epel']
    } else {
      $_require = undef
    }
  } else {
    $_require = undef
  }

  package { 'fail2ban':
    ensure  => $fail2ban::_package_ensure,
    name    => $fail2ban::package_name,
    require => $_require,
  }

}
