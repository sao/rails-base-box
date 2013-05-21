$databases  = ['rails_development', 'rails_test']
$home       = '/home/vagrant'
$ruby       = '2.0.0-p195'
Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# preinstall

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    command => 'apt-get -y update'
  }
}

class { 'apt_get_update':
  stage => preinstall
}

# sqlite

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# postgres

class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server': }

  pg_database { $databases:
    ensure   => present,
    encoding => 'UTF8',
    require  => Class['postgresql::server']
  }

  pg_user { 'rails':
    ensure   => present,
    password => 'rails',
    require  => Class['postgresql::server']
  }

  pg_user { 'vagrant':
    ensure    => present,
    password  => 'vagrant',
    superuser => true,
    require   => Class['postgresql::server']
  }

  package { 'libpq-dev':
    ensure => installed
  }

  package { 'postgresql-contrib':
    ensure  => installed,
    require => Class['postgresql::server'],
  }
}
class { 'install_postgres': }

# redis

class install_redis {
  class { 'redis':
    version => '2.6.13',
  }

  redis::instance { 'redis-6900':
    redis_port       => '6900',
    redis_password   => 'vagrant',
    redis_max_memory => '1gb',
  }
}
class { 'install_redis': }

# memcached

class { 'memcached': }

# packages

# Standard packages
package { ['curl', 'git', 'tmux', 'vim', 'vim-gtk', 'exuberant-ctags']:
  ensure => installed
}

# Development dependencies
package { ['libcurl4-openssl-dev', 'libksba8', 'libksba-dev', 'libqtwebkit-dev', 'imagemagick', 'watch']:
  ensure => installed
}

# Nokogiri dependencies
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime
package { 'nodejs':
  ensure => installed
}

# ruby

class install_rbenv {
  rbenv::install { 'vagrant':
    group => 'vagrant',
    home  => $home
  }
}
class { 'install_rbenv': }

class install_rbenv_plugins {
  require install_rbenv

  rbenv::plugin::rbenvvars { 'vagrant': }
}
class { 'install_rbenv_plugins': }

class install_ruby {
  require install_rbenv_plugins

  rbenv::compile { $ruby:
    user   => 'vagrant',
    home   => $home,
    global => true
  }
}
class { 'install_ruby': }

class install_gems {
  require install_ruby

  rbenv::gem { ['foreman', 'pg', 'thin']:
    user => 'vagrant',
    ruby => $ruby,
  }
}
class { 'install_gems': }
