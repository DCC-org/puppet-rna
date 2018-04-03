require 'spec_helper'

describe 'rna::mirror' do
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
        it { is_expected.to contain_class('rna::mirror') }
        it { is_expected.to contain_class('nginx') }
        it { is_expected.to contain_systemd__unit_file('syncrepo.service') }
        it { is_expected.to contain_systemd__unit_file('syncrepo.timer') }
        it { is_expected.to contain_nginx__resource__location('foo.example.com')}
        it { is_expected.to contain_nginx__resource__server('foo.example.com') }
        it { is_expected.to contain_file('/usr/local/bin/syncrepo') }
        it { is_expected.to contain_service('syncrepo.timer')}
     end
    end
  end
end
