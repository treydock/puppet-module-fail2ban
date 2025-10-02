# frozen_string_literal: true

Puppet::Type.type(:fail2ban_config).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:ruby),
) do
  desc 'Provider fail2ban_config using ini_setting'

  def section
    resource[:name].split('/', 2).first
  end

  def setting
    resource[:name].split('/', 2).last
  end

  def separator
    ' = '
  end

  def self.file_path
    '/etc/fail2ban/fail2ban.local'
  end
end
