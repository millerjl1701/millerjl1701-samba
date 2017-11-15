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

          it { is_expected.to contain_service('samba').with(
            'ensure'     => 'running',
            'enable'     => 'true',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
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
