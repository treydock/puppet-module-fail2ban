require 'puppet'
require 'puppet/type/fail2ban_config'

describe 'Puppet::Type.type(:fail2ban_config)' do
  before :each do
    @fail2ban_config = Puppet::Type.type(:fail2ban_config).new(:name => 'vars/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:fail2ban_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:fail2ban_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Invalid fail2ban_config/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:fail2ban_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Invalid fail2ban_config/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:fail2ban_config).new(:name => 'vars/foo', :ensure => :absent)
  end

  it 'should require a value when ensure is present' do
    expect {
      Puppet::Type.type(:fail2ban_config).new(:name => 'vars/foo', :ensure => :present)
    }.to raise_error(Puppet::Error, /Property value must be set/)
  end

  it 'should accept a valid value' do
    @fail2ban_config[:value] = 'bar'
    expect(@fail2ban_config[:value]).to eq('bar')
  end

  it 'should not accept a value with whitespace' do
    @fail2ban_config[:value] = 'b ar'
    expect(@fail2ban_config[:value]).to eq('b ar')
  end

  it 'should accept valid ensure values' do
    @fail2ban_config[:ensure] = :present
    expect(@fail2ban_config[:ensure]).to eq(:present)
    @fail2ban_config[:ensure] = :absent
    expect(@fail2ban_config[:ensure]).to eq(:absent)
  end

  it 'should not accept invalid ensure values' do
    expect {
      @fail2ban_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  describe 'autorequire File resources' do
    it 'should autorequire /etc/fail2ban/fail2ban.local' do
      conf = Puppet::Type.type(:file).new(:name => '/etc/fail2ban/fail2ban.local')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource @fail2ban_config
      catalog.add_resource conf
      rel = @fail2ban_config.autorequire[0]
      expect(rel.source.ref).to eq(conf.ref)
      expect(rel.target.ref).to eq(@fail2ban_config.ref)
    end
  end

end
