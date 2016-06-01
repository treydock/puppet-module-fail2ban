shared_context "fail2ban::config" do |facts|
  it do
    is_expected.to contain_file('/etc/fail2ban/fail2ban.local').with({
      :ensure  => 'file',
      :path    => '/etc/fail2ban/fail2ban.local',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    is_expected.to contain_file('/etc/fail2ban/jail.local').with({
      :ensure  => 'file',
      :path    => '/etc/fail2ban/jail.local',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it { is_expected.to contain_fail2ban_jail_config('DEFAULT/ignoreip').with_value('127.0.0.1/8') }
  it { is_expected.to contain_fail2ban_jail_config('DEFAULT/bantime').with_value('600') }
  it { is_expected.to contain_fail2ban_jail_config('DEFAULT/findtime').with_value('600') }
  it { is_expected.to contain_fail2ban_jail_config('DEFAULT/maxretry').with_value('5') }
end
