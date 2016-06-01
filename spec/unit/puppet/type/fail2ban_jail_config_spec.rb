require 'puppet'
require 'puppet/type/fail2ban_jail_config'

describe 'Puppet::Type.type(:fail2ban_jail_config)' do
  before :each do
    @fail2ban_jail_config = Puppet::Type.type(:fail2ban_jail_config).new(:name => 'vars/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:fail2ban_jail_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:fail2ban_jail_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Invalid fail2ban_jail_config/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:fail2ban_jail_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Invalid fail2ban_jail_config/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:fail2ban_jail_config).new(:name => 'vars/foo', :ensure => :absent)
  end

  it 'should require a value when ensure is present' do
    expect {
      Puppet::Type.type(:fail2ban_jail_config).new(:name => 'vars/foo', :ensure => :present)
    }.to raise_error(Puppet::Error, /Property value must be set/)
  end

  it 'should accept a valid value' do
    @fail2ban_jail_config[:value] = 'bar'
    @fail2ban_jail_config[:value].should == 'bar'
  end

  it 'should not accept a value with whitespace' do
    @fail2ban_jail_config[:value] = 'b ar'
    @fail2ban_jail_config[:value].should == 'b ar'
  end

  it 'should accept valid ensure values' do
    @fail2ban_jail_config[:ensure] = :present
    @fail2ban_jail_config[:ensure].should == :present
    @fail2ban_jail_config[:ensure] = :absent
    @fail2ban_jail_config[:ensure].should == :absent
  end

  it 'should not accept invalid ensure values' do
    expect {
      @fail2ban_jail_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  describe 'autorequire File resources' do
    it 'should autorequire /etc/fail2ban/jail.local' do
      conf = Puppet::Type.type(:file).new(:name => '/etc/fail2ban/jail.local')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource @fail2ban_jail_config
      catalog.add_resource conf
      rel = @fail2ban_jail_config.autorequire[0]
      rel.source.ref.should == conf.ref
      rel.target.ref.should == @fail2ban_jail_config.ref
    end
  end

end
