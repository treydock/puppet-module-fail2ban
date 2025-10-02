# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'fail2ban class:' do
  package_name = if fact('os.family') == 'RedHat'
                   'fail2ban-server'
                 else
                   'fail2ban'
                 end

  context 'with default parameters' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'fail2ban': }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe file('/etc/fail2ban/fail2ban.local') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe file('/etc/fail2ban/jail.local') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe service('fail2ban') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  context 'when ensure => absent' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'fail2ban': ensure => 'absent' }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package(package_name) do
      it { is_expected.not_to be_installed }
    end

    describe file('/etc/fail2ban/fail2ban.local') do
      it { is_expected.not_to be_file }
    end

    describe file('/etc/fail2ban/jail.local') do
      it { is_expected.not_to be_file }
    end

    describe service('fail2ban') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end
  end
end
