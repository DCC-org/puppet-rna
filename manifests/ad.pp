# this class is used to manage a Samba active directory
class rna::ad {

  # update /etc/hosts with an entry

  class{'samba::dc':
    domain             => 'ad',
    realm              => 'ad.example.org',
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
  }
}
