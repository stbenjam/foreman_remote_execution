require 'test_plugin_helper'

describe 'HostExtensions' do
  # FIXME: Using puppet proxy until http://projects.theforeman.org/issues/11554
  let(:host) { FactoryGirl.create(:host, :with_puppet) }
  let(:sshkey) { 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+GzpJ dummy@localhost' }

  describe '#remote_execution_ssh_key' do
    before do
      SmartProxy.find(host.all_host_proxies.first).features << FactoryGirl.create(:feature, :ssh)
      ::ProxyAPI::RemoteExecutionSSH.any_instance.expects(:sshkey).returns(sshkey)
    end

    it 'returns the ssh key' do
      assert_equal host.remote_execution_ssh_key, sshkey
    end

    it 'is allowed in the jail' do
      assert host.remote_execution_ssh_key.to_jail
    end
  end
end
