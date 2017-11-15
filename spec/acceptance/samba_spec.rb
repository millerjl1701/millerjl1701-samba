require 'spec_helper_acceptance'

describe 'samba class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'samba': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('samba') do
      it { should be_installed }
    end

    describe service('nmb') do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe service('smb') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
