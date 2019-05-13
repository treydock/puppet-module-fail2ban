require 'spec_helper'

describe 'fail2ban' do
  on_supported_os({
    :supported_os => [
      {
        "operatingsystem" => "RedHat",
        "operatingsystemrelease" => ["6", "7"],
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/dne',
        })
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('fail2ban') }

      it { is_expected.to contain_anchor('fail2ban::start').that_comes_before('Class[fail2ban::install]') }
      it { is_expected.to contain_class('fail2ban::install').that_comes_before('Class[fail2ban::config]') }
      it { is_expected.to contain_class('fail2ban::config').that_notifies('Class[fail2ban::service]') }
      it { is_expected.to contain_class('fail2ban::service').that_comes_before('Anchor[fail2ban::end]') }
      it { is_expected.to contain_anchor('fail2ban::end') }

      include_context 'fail2ban::install', facts
      include_context 'fail2ban::config', facts
      include_context 'fail2ban::service', facts

    end # end context
  end # end on_supported_os loop
end # end describe
