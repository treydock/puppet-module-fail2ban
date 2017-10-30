shared_context "fail2ban::config" do |facts|
  it do
    is_expected.to contain_resources('fail2ban_config').with_purge('true')
  end

  it do
    is_expected.to contain_resources('fail2ban_jail_config').with_purge('true')
  end

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

  it { is_expected.to contain_fail2ban_config('Definition/logtarget').with_value('/var/log/fail2ban.log') }
  it { is_expected.to contain_fail2ban_jail_config('DEFAULT/ignoreip').with_value('127.0.0.1/8') }
  it { is_expected.to contain_fail2ban_jail_config('DEFAULT/bantime').with_value('600') }
  it { is_expected.to contain_fail2ban_jail_config('DEFAULT/findtime').with_value('600') }
  it { is_expected.to contain_fail2ban_jail_config('DEFAULT/maxretry').with_value('5') }

  context 'with mutiple values for default_ignoreip' do
    let(:params) {{ :default_ignoreip => ['127.0.0.1/8', 'foo.example.com'] }}
    it { is_expected.to contain_fail2ban_jail_config('DEFAULT/ignoreip').with_value('127.0.0.1/8 foo.example.com') }
  end
end
