# this class is used to manage a Samba active directory
class rna::ad {

  # update /etc/hosts with an entry
  # update /etc/resolv.conf with 127.0.0.1

  class{'samba::dc':
    adminpassword      => '54edfghui85r4efghji8765!',
    domain             => 'ad',
    realm              => "ad.${rna::domain}",
    dnsbackend         => 'internal',
    domainlevel        => '2008 R2',
    sambaloglevel      => 1,
    logtosyslog        => true,
    ip                 => $facts['networking']['ip'],
    sambaclassloglevel => {
      'smb'   => 2,
      'idmap' => 2,
    },
    dnsforwarder       => $rna::dnsresolver,
    globaloptions      => {
      'load printers'   => 'no',
      'printing'        => 'bsd',
      'printcap name'   => '/dev/null',
      'disable spoolss' => 'yes',
    },
  }

  # add a test user to verify connections
  smb_user { 'testuser01':                          # * user name
    ensure             => present,                  # * absent | present
    password           => '23456jyuherteT!',        # * user password (default: random)
    force_password     => true,                     # * force password value, if false only set at creation (default: true)
    groups             => ['domain users'],         # * list of groups (default: [])
    given_name         => 'test user gn',           # * user given name (default: '')
    use_username_as_cn => true,                     # * use username as cn (default: false)
    attributes         => {                         # * hash of attributes
      uidNumber        => '15222',                  #   use list for multivalued attributes
      gidNumber        => '10003',                  #   (default: {} (no attributes))
      msSFU30NisDomain => 'dc',
      mail             => ['test@bastelfreak.de'],
    },
  }
}
