$app        = "vagrant"
$databases  = ["activerecord_unittest", "activerecord_unittest2"]
$as_vagrant = "sudo -u ${app} -H bash -l -c"
$home       = "/home/${app}"

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    command => "apt-get -y update"
  }
}
class { 'apt_get_update':
  stage => preinstall
}

# --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# --- PostgreSQL ---------------------------------------------------------------

class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server': }

  pg_database { $databases:
    ensure   => present,
    encoding => 'UTF8',
    require  => Class['postgresql::server']
  }

  pg_user { 'rails':
    ensure  => present,
    require => Class['postgresql::server']
  }

  pg_user { $app:
    ensure    => present,
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

# --- Memcached ----------------------------------------------------------------

class { 'memcached': }

# --- Packages -----------------------------------------------------------------

package { 'build-essential':
  ensure => installed
}

package { 'curl':
  ensure => installed
}

package { 'git':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# --- Ruby ---------------------------------------------------------------------

class install_rbenv {
  rbenv::install { $app:
    group => $app,
    home  => $home
  }
}
class { 'install_rbenv': }

class install_rbenv_plugins {
  require install_rbenv

  rbenv::plugin::rbenvvars { $app: }
}
class { 'install_rbenv_plugins': }

class install_ruby {
  require install_rbenv_plugins

  rbenv::compile { "2.0.0-p195":
    user => $app,
    home => $home
  }
}
class { 'install_ruby': }
