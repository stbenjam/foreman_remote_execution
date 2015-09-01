module ::ProxyAPI
  class RemoteExecutionSSH < ::ProxyAPI::Resource
    def initialize(args)
      @url = args[:url] + '/ssh'
      super args
    end

    def sshkey
      get('pubkey')
    rescue => e
      raise ProxyException.new(url, e, N_('Unable to get SSH key from Smart Proxy'))
    end
  end
end
