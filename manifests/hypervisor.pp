class rna::hypervisor {
  systemd::network{'virbr1.netdev':
    source          => "puppet:///modules/${module_name}/configs/virbr1.netdev",
    restart_service => true,
  }
  -> systemd::network{'virbr1.network':
    source          => "puppet:///modules/${module_name}/configs/virbr1.network",
    restart_service => true,
  }

  file{'/srv/http':
    ensure => 'directory',
  }
  -> file{'/srv/http/pxe':
    ensure => 'directory',
  }
  -> file{'/srv/http/pxe/menu.ipxe':
    source => "puppet:///modules/${module_name}/configs/menu.ipxe",
  }
  -> file{'/srv/tftp/boot.ipxe':
    source => "puppet:///modules/${module_name}/configs/boot.ipxe"
  }
  -> file{'/srv/tftp/boot.ipxe.cfg':
    source => "puppet:///modules/${module_name}/configs/boot.ipxe.cfg"
  }
  file{'/usr/local/bin/syncrepo':
    source => "puppet:///modules/${module_name}/scripts/syncrepo",
    owner  => 'root',
    group  => 'root',
  }
  ['ipxe.efi', 'ipxe.lkrn', 'ipxe.pxe'].each |String $filename| {
    file{"/srv/tftp/${filename}":
      ensure => 'file',
    }
  }
  # download arch iso
  file{'/srv/archiso':
    ensure => 'directory',
  }
  -> archive { '/srv/archlinux-2017.12.01-x86_64.iso':
    ensure          => present,
    extract         => true,
    extract_path    => '/srv/archiso',
    extract_command => '7z x %s',
    source          => 'https://fabric-mirror.vps.hosteurope.de/archlinux/iso/2017.12.01/archlinux-2017.12.01-x86_64.iso',
    checksum        => 'ec5e7c58520d7e1be72bc27c669d3c5fc94d6947',
    checksum_type   => 'sha1',
    creates         => '/srv/archiso/arch',
    cleanup         => true,
  }
  -> file{'/srv/archiso/isolinux':
    ensure => 'absent',
    force  => true,
  }
  -> file{'/srv/archiso/loader':
    ensure => 'absent',
    force  => true,
  }
  -> file{'/srv/archiso/EFI':
    ensure => 'absent',
    force  => true,
  }
  -> file{'/srv/archiso/[BOOT]':
    ensure => 'absent',
    force  => true,
  }

  class{'tftp':
    manage_root_dir => $rna::manage_root_dir,
  }

  file{'/srv/tftp/':
    recurse => true,
    source  => '/usr/lib/syslinux/bios/',
    purge   => false,
  }
  file{'/srv/tftp/pxelinux.cfg':
    ensure  => 'directory',
    #owner   => 'marmoset',
    #group   => 'marmoset',
    #require => User['marmoset'],
  }
  #file{'/srv/tftp/pxelinux.cfg/default':
    #ensure => file,
    #owner  => 'root',
    #group  => 'root',
    #mode   => '0644',
    # source => 'puppet:///modules/profiles/configs/pxelinux_default',
    #  }

    # libvirt foo. qemu.conf edited

    # add archive resource for downloading undionly
}
