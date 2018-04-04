class rna::archlinux {
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
  file{'/etc/vconsole.conf':
    path    => '/etc/vconsole.conf',
    content => "KEYMAP=de-latin1-nodeadkeys\n",
  }
  file{'/etc/pacman.d/mirrorlist':
    path    => '/etc/pacman.d/mirrorlist',
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
    require => File['/etc/pacman.d/mirrorlist'],
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
}
