# frozen_string_literal: true

#
# these tests are a little concerning b/c they are hacking around the
# modulepath, so these tests will not catch issues that may eventually arise
# related to loading these plugins.
# I could not, for the life of me, figure out how to programatcally set the modulepath
$LOAD_PATH.push(
  File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    '..',
    'fixtures',
    'modules',
    'inifile',
    'lib',
  ),
)

require 'puppet'
require 'puppet/type/fail2ban_config'

describe 'Puppet::Type.type(:fail2ban_config)' do
  let(:fail2ban_config) do
    Puppet::Type.type(:fail2ban_config).new(name: 'vars/foo', value: 'bar')
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:fail2ban_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'does not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:fail2ban_config).new(name: 'f oo')
    }.to raise_error(Puppet::Error, %r{Invalid fail2ban_config})
  end

  it 'fails when there is no section' do
    expect {
      Puppet::Type.type(:fail2ban_config).new(name: 'foo')
    }.to raise_error(Puppet::Error, %r{Invalid fail2ban_config})
  end

  it 'does not require a value when ensure is absent' do
    Puppet::Type.type(:fail2ban_config).new(name: 'vars/foo', ensure: :absent)
  end

  it 'requires a value when ensure is present' do
    expect {
      Puppet::Type.type(:fail2ban_config).new(name: 'vars/foo', ensure: :present)
    }.to raise_error(Puppet::Error, %r{Property value must be set})
  end

  it 'accepts a valid value' do
    fail2ban_config[:value] = 'bar'
    expect(fail2ban_config[:value]).to eq('bar')
  end

  it 'does not accept a value with whitespace' do
    fail2ban_config[:value] = 'b ar'
    expect(fail2ban_config[:value]).to eq('b ar')
  end

  it 'accepts valid ensure values' do
    fail2ban_config[:ensure] = :present
    expect(fail2ban_config[:ensure]).to eq(:present)
    fail2ban_config[:ensure] = :absent
    expect(fail2ban_config[:ensure]).to eq(:absent)
  end

  it 'does not accept invalid ensure values' do
    expect {
      fail2ban_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, %r{Invalid value})
  end

  describe 'autorequire File resources' do
    it 'autorequires /etc/fail2ban/fail2ban.local' do
      conf = Puppet::Type.type(:file).new(name: '/etc/fail2ban/fail2ban.local')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource fail2ban_config
      catalog.add_resource conf
      rel = fail2ban_config.autorequire[0]
      expect(rel.source.ref).to eq(conf.ref)
      expect(rel.target.ref).to eq(fail2ban_config.ref)
    end
  end
end
