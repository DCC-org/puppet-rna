require 'spec_helper'

describe 'rna::ad' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let :pre_condition do
        'include rna'
      end
      describe 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('rna::ad') }
        it { is_expected.to contain_class('samba::dc') }
        it { is_expected.to contain_smb_user('testuser01') }
     end
    end
  end
end
