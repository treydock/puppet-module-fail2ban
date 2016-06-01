require 'spec_helper_acceptance'

describe 'fail2ban class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'fail2ban': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('fail2ban') do
      it { should be_installed }
    end

    describe file('/etc/fail2ban/fail2ban.local') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/fail2ban/jail.local') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe service('fail2ban') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
