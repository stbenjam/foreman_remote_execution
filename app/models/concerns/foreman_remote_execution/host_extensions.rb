module ForemanRemoteExecution
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      has_many :targeting_hosts, :dependent => :destroy, :foreign_key => 'host_id'
    end

    def remote_execution_ssh_key
      if (proxy = remote_execution_proxy('Ssh'))
        ProxyAPI::RemoteExecutionSSH.new(:url => proxy.url).sshkey
      end
    end

    def remote_execution_proxy(provider = 'Ssh')
      all_host_proxies.each do |proxies|
        return proxies.find { |proxy| proxy.has_feature?(provider) }
      end
      raise _("Could not use any proxy: assign a proxy with provider '%{provider}' to the host or set '%{global_proxy_setting}' in settings") % { :provider => provider, :global_proxy_setting => 'remote_execution_global_proxy' }
    end

    def all_host_proxies
      Enumerator.new do |e|
        interfaces.each do |interface|
          if interface.subnet
            interface_proxies = ::SmartProxy.where(:id => interface.subnet.proxies.map(&:id))
            e << interface_proxies unless interface_proxies.blank?
          end
        end
        e << smart_proxies unless smart_proxies.blank?
        e << ::SmartProxy.authorized if Setting[:remote_execution_global_proxy]
      end
    end
  end
end

class ::Host::Managed::Jail < Safemode::Jail
    allow :remote_execution_ssh_key
end
