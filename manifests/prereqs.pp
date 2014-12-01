# == Class: redis::prereqs
#
#
class redis::prereqs {

  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      ensure_packages ( 'build-essential')
    }
    'Fedora', 'RedHat', 'CentOS', 'OEL', 'OracleLinux', 'Amazon': {
      ensure_packages( 'make','gcc','glibc-devel' )
    }
    default: {
      fail('The module does not support this OS.')
    }
  }

}

