class redis::healthcheck ( ) {

  include xinetd

  ensure_packages(['redis-tools'])

}

  define redis::healthcheck::xinetd ( $redisip, $redisport, $healthcheckport )  {

    file { "/usr/sbin/redis-role-$name.sh":
      ensure => file,
      content => template('redis/redis-role.sh.erb'),
      owner  => root,
      group  => root,
      mode   => '0755',
    }

    xinetd::service { "redis-$name":
      flags           => REUSE,
      socket_type     => stream,
      port            => $healthcheckport,
      wait            => no,
      user            => nobody,
      server          => "/usr/sbin/redis-role-$name.sh",
      log_on_failure  => USERID,
      disable         => no,
      only_from       => '0.0.0.0/0',
      per_source      => UNLIMITED,
    }

   augeas { "xinet-service-redis-$name":
      context => '/files/etc/services',
      changes => [
        "set service-name[port = '$healthcheckport']/port $healthcheckport",
        "set service-name[port = '$healthcheckport'] redis-$name",
        "set service-name[port = '$healthcheckport']/protocol tcp",
        "set service-name[port = '$healthcheckport']/#comment redis-$name-healthcheck",
      ],
    }

  }
