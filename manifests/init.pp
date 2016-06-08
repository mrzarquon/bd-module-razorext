# this is a simple module that zips up all synced facts hosted on a razor server
# enabling for easy distribution of facts to all razor mk clients
# to use, ensure the facts you want on mk clients are in the same environment as
# the razor server and this module

class razorext {

  $directories = ['/opt/puppetlabs/razorext',
    '/opt/puppetlabs/razorext/lib',
    '/opt/puppetlabs/razorext/lib/ruby',
    '/opt/puppetlabs/razorext/lib/ruby/facter']

  package {['zip','rsync']:
    ensure => present,
    before => Exec['rsync_and_zip_extensions'],
  }

  file { $directories:
    ensure => directory,
    owner => root,
    group => root,
    chmod => 0644,
  }

  exec {'rsync_and_zip_extensions':
    command => '/bin/zip -r mk-extensions.zip lib',
    onlyif  => '/bin/rsync --log-format=%f -a /opt/puppetlabs/puppet/cache/lib/facter/ /opt/puppetlabs/razorfacts/lib/ruby/facter | grep opt/puppetlabs',
    cwd     => '/opt/puppetlabs/razorext/',
    path    => '/bin',
  }

  file {'/opt/puppetlabs/razorfacts/mk-extensions.zip':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Exec['rsync_and_zip_extensions'],
  }


  yaml_setting { 'set-razor-extensions-md':
    target  => '/etc/puppetlabs/razor-server/config.yaml',
    key     => 'all/microkernel/extension-zip',
    value   => ['/opt/puppetlabs/razorfacts/mk-extensions.zip'],
    require => [
      Exec['rsync_and_zip_extensions'],
      File['/opt/puppetlabs/razorfacts/mk-extensions.zip']
    ],
    notify  => Service['pe-razor-server'],
  }
}
