require 'spec_helper'

describe 'rna::network' do
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
        it { is_expected.to contain_class('rna::network') }
        it { is_expected.to contain_ini_setting('LLDP') }
        it { is_expected.to contain_ini_setting('LLMNR') }
        it { is_expected.to contain_ini_setting('MulticastDNS') }
     end
    end
  end
end
