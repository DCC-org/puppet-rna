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
