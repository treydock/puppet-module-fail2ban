shared_context "fail2ban::install" do |facts|
  if facts[:operatingsystem] == 'RedHat'
    package_require = 'Class[Epel]'
  else
    package_require = nil
  end

  it do
    is_expected.to contain_package('fail2ban').only_with({
      :ensure   => 'present',
      :name     => 'fail2ban',
      :require  => package_require,
    })
  end
end
