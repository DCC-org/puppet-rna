# this class is used to manage a Samba active directory
class rna::ad {

  # update /etc/hosts with an entry

  package{$rna::ad::packages:
    ensure => 'present'
  }
}
