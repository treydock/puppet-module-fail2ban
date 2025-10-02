# frozen_string_literal: true

require 'spec_helper'

describe 'fail2ban' do
  on_supported_os.each do |os, facts|
    context "when #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('fail2ban') }

      it { is_expected.to contain_class('fail2ban::install').that_comes_before('Class[fail2ban::config]') }
      it { is_expected.to contain_class('fail2ban::config').that_notifies('Class[fail2ban::service]') }
      it { is_expected.to contain_class('fail2ban::service') }

      describe 'fail2ban::install' do
        if facts[:os]['family'] == 'RedHat'
          package_require = 'Class[Epel]'
          name = 'fail2ban-server'
        else
          package_require = nil
          name = 'fail2ban'
        end

        it do
          is_expected.to contain_package('fail2ban').only_with(ensure: 'present',
                                                               name: name,
                                                               require: package_require,)
        end
      end

      describe 'fail2ban::config' do
        it do
          is_expected.to contain_resources('fail2ban_config').with_purge('true')
        end

        it do
          is_expected.to contain_resources('fail2ban_jail_config').with_purge('true')
        end

        it do
          is_expected.to contain_file('/etc/fail2ban/fail2ban.local').with(ensure: 'file',
                                                                           path: '/etc/fail2ban/fail2ban.local',
                                                                           owner: 'root',
                                                                           group: 'root',
                                                                           mode: '0644',)
        end

        it do
          is_expected.to contain_file('/etc/fail2ban/jail.local').with(ensure: 'file',
                                                                       path: '/etc/fail2ban/jail.local',
                                                                       owner: 'root',
                                                                       group: 'root',
                                                                       mode: '0644',)
        end

        it { is_expected.to contain_fail2ban_config('Definition/logtarget').with_value('/var/log/fail2ban.log') }
        it { is_expected.to contain_fail2ban_jail_config('DEFAULT/ignoreip').with_value('127.0.0.1/8') }
        it { is_expected.to contain_fail2ban_jail_config('DEFAULT/bantime').with_value('600') }
        it { is_expected.to contain_fail2ban_jail_config('DEFAULT/findtime').with_value('600') }
        it { is_expected.to contain_fail2ban_jail_config('DEFAULT/maxretry').with_value('5') }

        context 'with mutiple values for default_ignoreip' do
          let(:params) { { default_ignoreip: ['127.0.0.1/8', 'foo.example.com'] } }

          it { is_expected.to contain_fail2ban_jail_config('DEFAULT/ignoreip').with_value('127.0.0.1/8 foo.example.com') }
        end
      end

      describe 'fail2ban::service' do
        it do
          is_expected.to contain_service('fail2ban').only_with(ensure: 'running',
                                                               enable: 'true',
                                                               name: 'fail2ban',)
        end
      end
    end
  end
end
