class rna (
  Boolean $manage_root_dir,
  Array $packages,
  Boolean $manage_resolved,
  Boolean $manage_networkd,
  Boolean $manage_timesyncd,
  Stdlib::Absolutepath $www_root,
  Boolean $manage_configfile,
  Boolean $manage_service,
  Stdlib::Ip_address $dnsresolver,
  String $domain,
){

  case $facts['os']['family'] {
    'Archlinux': {
      include rna::archlinux
    }
    'RedHat': {
      include rna::redhat
    }
    default: {}
  }

  case $facts['fqdn'] {
    /hypervisor/: {
      include rna::hypervisor
      include rna::mirror
      $dns = '62.138.188.16'
    }
    /samba/: {
      include rna::ad
      $dns = '127.0.0.1'
    }
    /puppet/: {
      include rna::puppetaio
      $dns = '62.138.188.16'
    }
    default: {
      $dns = '62.138.188.16'
    }
  }

  if $rna::manage_networkd {
    include rna::network
  }

  # setup kerberos
  class{'kerberos':
    default_realm    => "AD.${upcase($domain)}",
    dns_lookup_kdc   => true,
    dns_lookup_realm => true,
  }
  kerberos::realm{$domain:
    kdc => "ad.${domain}",
  }

  class{'systemd':
    manage_resolved  => $rna::manage_resolved,
    manage_networkd  => $rna::manage_networkd,
    manage_timesyncd => $rna::manage_timesyncd,
    dns              => $dns,
  }
  package{$packages:
    ensure => 'present',
  }
  service{'haveged':
    ensure  => 'running',
    enable  => true,
    require => Package['haveged'],
  }

  service{'vnstat':
    ensure  => running,
    enable  => true,
    require => Package['vnstat'],
  }

  include lldpd

  # only install megacli/storcli on physical machines
  if $facts['is_virtual'] == false {
    include megaraid
  }

  # basic firewalling
  # drop everything except for ssh and ICMP
  class{'ferm':
    manage_configfile => $rna::manage_configfile,
    manage_service    => $rna::manage_service,
  }

  ferm::rule{'allow_ssh':
    chain  => 'INPUT',
    policy => 'ACCEPT',
    proto  => 'tcp',
    dport  => '22',
  }

  ferm::rule{'allow_icmp':
    chain  => 'INPUT',
    policy => 'ACCEPT',
    proto  => 'icmp',
  }

  # do a pluginsync in agentless setup
  # lint:ignore:puppet_url_without_modules
  file { $::settings::libdir:
    ensure  => directory,
    source  => 'puppet:///plugins',
    recurse => true,
    purge   => true,
    backup  => false,
    noop    => false,
  }
  # lint:endignore

  # configure bash/vim
  vcsrepo{'/root/.vim/bundle/Vundle.vim':
    ensure   => 'present',
    source   => 'https://github.com/gmarik/Vundle.vim.git',
    provider => 'git',
    owner    => 'root',
    user     => 'root',
  }
  vcsrepo{'/root/scripts':
    ensure   => 'present',
    source   => 'https://github.com/bastelfreak/scripts.git',
    provider => 'git',
    owner    => 'root',
    user     => 'root',
  }

  file{'/root/.vim':
    ensure => 'directory',
  }
  -> file{'/root/.vim/backupdir':
    ensure => 'directory',
  }
  file{'/root/.vimrc':
    ensure => 'file',
    source => "puppet:///modules/${module_name}/configs/vimrc",
  }
  file{'/root/.bashrc':
    ensure => 'file',
    source => "puppet:///modules/${module_name}/configs/bashrc",
  }
  file{'/root/.bash_profile':
    ensure => 'file',
    source => "puppet:///modules/${module_name}/configs/bash_profile",
  }

  # overwrite inputrc
  # this provides us proper history searching
  file{'/etc/inputrc':
    ensure => 'file',
    source => "puppet:///modules/${module_name}/configs/inputrc",
  }


}
