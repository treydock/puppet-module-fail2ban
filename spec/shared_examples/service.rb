shared_context "fail2ban::service" do |facts|
  it do
    is_expected.to contain_service('fail2ban').only_with({
      :ensure      => 'running',
      :enable      => 'true',
      :name        => 'fail2ban',
      :hasstatus   => 'true',
      :hasrestart  => 'true',
    })
  end
end
