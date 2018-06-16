class rna::redhat {
  package{['kernel-tools-libs',
            'kernel-tools',
            'chrony',
            'avahi-autoipd',
            'avahi',
            'NetworkManager-adsl',
            'NetworkManager-bluetooth',
            'NetworkManager-team',
            'NetworkManager-tui',
            'NetworkManager-wifi',
            'NetworkManager-wwan',
            'NetworkManager',
            'firewalld',
            'firewalld-filesystem',
            'python-firewall',]:
    ensure  => absent,
  }
}
