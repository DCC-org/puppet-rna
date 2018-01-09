require 'spec_helper'

describe 'rna' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it {is_expected.to contain_class('rna::hypervisor')}
        it {is_expected.to contain_class('rna::network')}
        it {is_expected.to contain_class('rna::mirror')}
        it { is_expected.to contain_package('bash-completion')}
        it { is_expected.to contain_package('lsof')}
        it { is_expected.to contain_package('bash')}
        it { is_expected.to contain_package('vim')}
        it { is_expected.to contain_package('gptfdisk')}
        it { is_expected.to contain_package('net-tools')}
        it { is_expected.to contain_package('bind-tools')}
        it { is_expected.to contain_package('ferm')}
        it { is_expected.to contain_package('whois')}
        it { is_expected.to contain_package('mtr')}
        it { is_expected.to contain_package('dfc')}
        it { is_expected.to contain_package('tree')}
        it { is_expected.to contain_package('ethtool')}
        it { is_expected.to contain_package('cpupower')}
        it { is_expected.to contain_package('ruby-augeas')}
        it { is_expected.to contain_package('rsync')}
        it { is_expected.to contain_package('intel-ucode')}
        it { is_expected.to contain_package('iperf3')}
        it { is_expected.to contain_package('haveged')}
        it { is_expected.to contain_package('cpio')}
        it { is_expected.to contain_package('parted')}
        it { is_expected.to contain_package('atop')}
        it { is_expected.to contain_package('unzip')}
        it { is_expected.to contain_package('libvirt')}
        it { is_expected.to contain_package('qemu-headless')}
        it { is_expected.to contain_package('ebtables')}
        it { is_expected.to contain_package('vnstat')}
        it { is_expected.to contain_package('linux-hardened')}
        it { is_expected.to contain_package('linux-hardened-docs')}
        it { is_expected.to contain_package('linux-hardened-headers')}
        it { is_expected.to contain_package('bash-completion')}
        it { is_expected.to contain_package('bridge-utils')}
        it { is_expected.to contain_package('p7zip')}
        it { is_expected.to contain_package('ccze')}
        it { is_expected.to contain_package('python')}
        it { is_expected.to contain_package('tcpdump')}
        it { is_expected.to contain_package('efibootmgr')}
        it { is_expected.to contain_package('efivar')}
        it { is_expected.to contain_package('ovmf')}
        it { is_expected.to contain_package('smartmontools')}
        it { is_expected.to contain_package('arch-audit')}
        it { is_expected.to contain_package('di')}
        it { is_expected.to contain_package('dmidecode')}
        it { is_expected.to contain_package('htop')}
        it { is_expected.to contain_package('iftop')}
        it { is_expected.to contain_package('ipmitool')}
        it { is_expected.to contain_package('nload')}
        it { is_expected.to contain_package('pkgfile')}
        it { is_expected.to contain_package('pigz')}
        it { is_expected.to contain_package('psmisc')}
        it { is_expected.to contain_package('screen')}
        it { is_expected.to contain_package('sudo')}
        it { is_expected.to contain_package('tmux')}

      end
    end
  end
end
