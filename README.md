# puppet-rna

A module to manage archlinux settings, specific for VMs and hypervisors

---

## Development

You can install all needed gems for testing with:

```
bundle install --path .vendor/ --without system_tests --without development --without release; bundle update; bundle clean
```

And execute tests:

```
bundle exec rake test
```

## Troubleshooting

### samba can't update DNS entries

check if you use the correct resolver ip address. On the samba server the `/etc/resolv.conf` should contain `nameserver 127.0.0.1`

### Debug authentication

You can use the following command to check if a user/password is valid:

```sh
smbclient //localhost/netlogon -UAdministrator -c 'ls'
```

and the output should look like this:

```
Enter AD\Administrator's password:
  .                                   D        0  Tue Apr  3 14:49:13 2018
  ..                                  D        0  Tue Apr  3 14:49:16 2018

    51340768 blocks of size 1024. 45363928 blocks available
```

### Debug kerberos

You should be able to get a ticket with this command:

```sh
kinit administrator
```

You maybe get the error:

```
kinit: Client 'administrator@ATHENA.MIT.EDU' not found in Kerberos database while getting initial credentials
```

This means that something is wrong in your local kinit config. You can set the realm by hand:

```sh
# kinit administrator@AD.EXAMPLE.ORG
Password for administrator@AD.EXAMPLE.ORG:
Warning: Your password will expire in 41 days on Tue 15 May 2018 05:28:06 PM UTC
```

Please keep in mind that the realm needs to be in uppercase.

You can list all tickets with `klist`:

```sh
# klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: administrator@AD.EXAMPLE.ORG

Valid starting       Expires              Service principal
04/03/2018 17:54:32  04/04/2018 03:54:32  krbtgt/AD.EXAMPLE.ORG@AD.EXAMPLE.ORG
  renew until 04/04/2018 17:54:21
```

## Naming convention

This module assumes a few things:

* Samba Active Director servers need to contain `samba` in their FQDN. Tested Operating System is Archlinux
* The Puppetserver needs to contain `puppet` in his FQDN. Tested Operating System is CentOS 7
