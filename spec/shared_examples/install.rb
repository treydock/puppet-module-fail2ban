shared_context "fail2ban::install" do |facts|
  if facts[:operatingsystem] == 'RedHat'
    package_require = 'Class[Epel]'
    if facts[:operatingsystemmajrelease] == '7'
      name = 'fail2ban-server'
    else
      name = 'fail2ban'
    end
  else
    package_require = nil
  end

  it do
    is_expected.to contain_package('fail2ban').only_with({
      :ensure   => 'present',
      :name     => name,
      :require  => package_require,
    })
  end
end
