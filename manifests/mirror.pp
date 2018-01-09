class rna::mirror {
  file{'/usr/local/bin/syncrepo':
    source => "puppet:///modules/${module_name}/scripts/syncrepo",
    owner  => 'root',
    group  => 'root',
  }
  systemd::unit_file{'syncrepo.service':
    source => "puppet:///modules/${module_name}/configs/syncrepo.service",
  }
  -> systemd::unit_file{'syncrepo.timer':
    source => "puppet:///modules/${module_name}/configs/syncrepo.timer",
  }
  -> service{'syncrepo.timer':
    ensure => 'running',
    enable => true,
  }

  include nginx
  nginx::resource::server{$facts['fqdn']:
    www_root    => $rna::www_root,
    server_name => [$facts['fqdn'], '192.168.123.1'],
  }
}
