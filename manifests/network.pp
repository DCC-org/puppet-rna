class rna::network {
  Ini_setting{
    ensure    => 'present',
    path      => '/etc/systemd/network/wired.network',
    section   => 'Network',
    value     => true,
    show_diff => true,
  }
  ['MulticastDNS', 'LLDP', 'LLMNR'].each |$option| {
    ini_setting{$option:
      setting => $option,
    }
  }

  # use ferm module here?
}
