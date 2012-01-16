class common {
  include ruby

  cron { "ntpdate_set":
    command => "/usr/sbin/ntpdate ntp.ubuntu.com",
    hour => [10], #times are UTC!
    minute => fqdn_rand(59)
  }

  file {'/etc/sudoers':
    ensure => 'present',
    mode => 440,
    source  => "puppet:///modules/common/sudoers"
  }

  file {'/etc/environment':
    ensure => 'present',
    source  => ["/data/config/environment", "/data/config/environment.generated"],
    require => [ File['/data/config/environment.generated'] ]
  }

  file {["/data", "/data/config"]:
    ensure => "directory", 
    owner => "spree", 
    group => "www-data", 
    mode => 660 
  }

  file {'/data/config/environment.generated':
    content  => template("common/environment.erb"),
    require => [ File['/data'], File['/data/config'] ]
  }
}
