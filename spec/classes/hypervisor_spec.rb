require 'spec_helper'

describe 'rna::hypervisor' do
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
        it { is_expected.to contain_class('rna::hypervisor') }
        it { is_expected.to contain_systemd__network('virbr1.netdev') }
        it { is_expected.to contain_systemd__network('virbr1.network') }
        it { is_expected.to contain_file('/srv/tftp/boot.ipxe.cfg') }
        it { is_expected.to contain_file('/srv/tftp/boot.ipxe') }
        it { is_expected.to contain_file('/srv/tftp/ipxe.efi') }
        it { is_expected.to contain_file('/srv/tftp/ipxe.lkrn') }
        it { is_expected.to contain_file('/srv/tftp/ipxe.pxe') }
        it { is_expected.to contain_archive('/srv/archlinux-2017.12.01-x86_64.iso')}
        it { is_expected.to contain_file('/srv/archiso/EFI') }
        it { is_expected.to contain_file('/srv/archiso/[BOOT]') }
        it { is_expected.to contain_file('/srv/archiso/arch') }
        it { is_expected.to contain_file('/srv/archiso/isolinux') }
        it { is_expected.to contain_file('/srv/archiso/loader') }
        it { is_expected.to contain_file('/srv/archiso') }
        it { is_expected.to contain_file('/srv/http/pxe/menu.ipxe') }
        it { is_expected.to contain_file('/srv/http/pxe') }
        it { is_expected.to contain_file('/srv/http') }
        it { is_expected.to contain_file('/srv/tftp/') }

     end
    end
  end
end
