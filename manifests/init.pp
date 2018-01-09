class rna (
 Boolean $manage_root_dir,
 Array $packages,
 Boolean $manage_resolved,
 Boolean $manage_networkd,
 Boolean $manage_timesyncd,
 Stdlib::Absolutepath $www_root,
){

  include rna::network
  include rna::hypervisor
  include rna::mirror

  class{'systemd':
    manage_resolved  => $rna::manage_resolved,
    manage_networkd  => $rna::manage_networkd,
    manage_timesyncd => $rna::manage_timesyncd,
  }
  package{$packages:
    ensure => 'present',
  }
   service{'haveged':
    ensure  => 'running',
    enable  => true,
    require => Package['haveged'],
  }
  package{'pkgfile':
    ensure => 'present',
    notify => Exec['update-pkgfile-db'],
  }
  exec{'update-pkgfile-db':
    command     => '/usr/bin/pkgfile --update',
    refreshonly => true,
  }

  #language
  file_line{'set-locale':
    path   => '/etc/locale.conf',
    line   => 'LANG=en_US.UTF-8',
    match  => 'LANG=',
    notify => Exec['rebuild-locales'],
  }
  exec{'rebuild-locales':
    command     => '/usr/bin/locale-gen',
    refreshonly => true,
  }

  #keyboard layout
  file{'set-keyboardlayout':
    path    => '/etc/vconsole.conf',
    content => "KEYMAP=de-latin1-nodeadkeys\n",
  }
  file{'archlinux-mirror':
    path  => '/etc/pacman.d/mirrorlist',
    content => "Server = http://mirror.virtapi.org/archlinux/\$repo/os/\$arch/\n",
  }
  # define our AUR repo
  Ini_setting{
    ensure  => 'present',
    path    => '/etc/pacman.conf',
    section => 'aur',
  }
  ini_setting{'SigLevel':
    setting => 'SigLevel',
    value   => 'Optional TrustAll',
  }
  -> ini_setting{'mirrorurl':
    setting => 'Include',
    value   => '/etc/pacman.d/mirrorlist',
    require => File['archlinux-mirror'],
  }
   service{'vnstat':
    ensure  => running,
    enable  => true,
    require => Package['vnstat'],
  }
  # deploy fact + systemd timer to report installed packages from the aur repository
  file{'/usr/local/bin/getallaurpackages':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${module_name}/scripts/getallaurpackages",
    mode   => '0755',
  }
  ::systemd::unit_file{'getallaurpackages.service':
    source => "puppet:///modules/${module_name}/configs/getallaurpackages.service",
  }
  -> ::systemd::unit_file{'getallaurpackages.timer':
    source => "puppet:///modules/${module_name}/configs/getallaurpackages.timer",
  }
  -> service{'getallaurpackages.timer':
    ensure => 'running',
    enable => true,
  }
  # make iostat colorized
  file{'/etc/profile.d/colorsysstat.sh':
    ensure => 'file',
    source => "puppet:///modules/${module_name}/configs/colorsysstat.sh",
  }

  include lldpd
  include megaraid

  # do a pluginsync in agentless setup
  file { $::settings::libdir:
    ensure  => directory,
    source  => 'puppet:///plugins',
    recurse => true,
    purge   => true,
    backup  => false,
    noop    => false
  }
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
}
