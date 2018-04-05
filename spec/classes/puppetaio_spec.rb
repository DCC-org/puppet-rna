require 'spec_helper'

describe 'rna::puppetaio' do
  on_supported_os.each do |os, facts|
    next if os =~ /archlinux/
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let :pre_condition do
        'include rna'
      end
      describe 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('rna::puppetaio') }
        it { is_expected.to contain_postgresql__server__db('foreman') }
        it { is_expected.to contain_selinux__module('foreman_tmu') }
     end
    end
  end
end
