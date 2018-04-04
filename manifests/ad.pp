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
      'disable spoolss' => 'yes'
    }
  }
}
