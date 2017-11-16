require 'spec_helper'

describe 'samba' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "samba class without any parameters changed from defaults" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('samba::install') }
          it { is_expected.to contain_class('samba::config') }
          it { is_expected.to contain_class('samba::service') }
          it { is_expected.to contain_class('samba::install').that_comes_before('Class[samba::config]') }
          it { is_expected.to contain_class('samba::service').that_subscribes_to('Class[samba::config]') }

          it { is_expected.to contain_package('samba').with_ensure('present') }

          it { is_expected.to contain_concat('/etc/samba/smb.conf').with(
            'ensure' => 'present',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0644',
            'path'   => '/etc/samba/smb.conf',
          ) }

          it { is_expected.to contain_concat__fragment('global').with(
            'target' => '/etc/samba/smb.conf',
            'order'  => '0_global',
          ) }

          it { is_expected.to_not contain_concat__fragment('shares') }

          it { is_expected.to contain_service('nmb').with(
            'ensure'     => 'stopped',
            'enable'     => 'false',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
          ) }

          it { is_expected.to contain_service('smb').with(
            'ensure'     => 'running',
            'enable'     => 'true',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
          ) }
        end

        context "samba class with config_dir set to /foo" do
          let(:params){
            {
              :config_dir => '/foo',
            }
          }

          it { is_expected.to contain_concat('/foo/smb.conf').with_path('/foo/smb.conf') }
          it { is_expected.to contain_concat__fragment('global').with_target('/foo/smb.conf') }
        end

        context "samba class with config_file set to foo.conf" do
          let(:params){
            {
              :config_file => 'foo.conf',
            }
          }

          it { is_expected.to contain_concat('/etc/samba/foo.conf').with_path('/etc/samba/foo.conf') }
          it { is_expected.to contain_concat__fragment('global').with_target('/etc/samba/foo.conf') }
        end

        context "samba class with package_ensure set to false" do
          let(:params){
            {
              :package_ensure => 'absent',
            }
          }

          it { is_expected.to contain_package('samba').with_ensure('absent') }
        end

        context "samba class with package_name set to foo" do
          let(:params){
            {
              :package_name => 'foo',
            }
          }

          it { is_expected.to_not contain_package('samba') }
          it { is_expected.to contain_package('foo') }
        end

        context "samba class with nmb service enabled and running" do
          let(:params){
            {
              :service_nmb_enable => true,
              :service_nmb_ensure => 'running',
            }
          }

          it { is_expected.to contain_service('nmb').with(
            'enable' => 'true',
            'ensure' => 'running',
          ) }
        end

        context "samba class with service_nmb_name set to foo" do
          let(:params){
            {
              :service_nmb_name => 'foo',
            }
          }

          it { is_expected.to_not contain_service('nmb') }
          it { is_expected.to contain_service('foo') }
        end

        context "samba class with smb service disabled and stopped" do
          let(:params){
            {
              :service_nmb_enable => false,
              :service_nmb_ensure => 'stopped',
            }
          }

          it { is_expected.to contain_service('nmb').with(
            'enable' => 'false',
            'ensure' => 'stopped',
          ) }
        end

        context "samba class with service_smb_name set to foo" do
          let(:params){
            {
              :service_smb_name => 'foo',
            }
          }

          it { is_expected.to_not contain_service('smb') }
          it { is_expected.to contain_service('foo') }
        end

        context "samba class with shares_definitions defined in hiera or class parameter" do
          let(:params){
            {
              :shares_definitions => { 'public' => { 'comment' => 'Public Stuff', 'path' => '/home/samba', 'public' => 'yes', 'writable' => 'yes', 'printable' => 'no' }, },
            }
          }

          it { is_expected.to contain_concat__fragment('shares').with(
            'target' => '/etc/samba/smb.conf',
            'order'  => 'shares',
          ) }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'samba class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('samba') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
