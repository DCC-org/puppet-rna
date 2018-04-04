class rna::hypervisor {
  # get windows driver
  archive{'/var/lib/libvirt/images/virtio-win.iso':
    ensure => 'present',
    extract => false,
    source => 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso',
  }
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
  ['boot.ipxe', 'boot.ipxe.cfg', 'ipxe.efi', 'ipxe.lkrn', 'ipxe.pxe'].each |String $filename| {
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
  file{'/srv/archiso/arch':
    ensure  => 'directory',
    recurse => true,
    mode    => '0755',
  }

  class{'tftp':
    manage_root_dir => $rna::manage_root_dir,
  }

  file{'/srv/tftp/':
    recurse => true,
    source  => '/usr/lib/syslinux/bios/',
    purge   => false,
  }
    # libvirt foo. qemu.conf edited
}
