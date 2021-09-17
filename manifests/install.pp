# Private class.
class fail2ban::install {
  assert_private()

  if $fail2ban::manage_repo and $fail2ban::ensure == 'present' {
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
