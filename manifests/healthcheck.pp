class redis::healthchecks ( ) {

  ensure_packages(['redis-cli'])  


  define redis::healthcheck ( $redisip, $redisport, $healthcheckport )  {

    file { "/usr/sbin/redis-role.sh-$name":
      ensure => file,
      content => template('redis/redis-role.sh.erb'),
      owner  => root,
      group  => root,
      mode   => '0755',
    }  

    xinetd::service { "redis-$name":
      flags           = REUSE
      socket_type     = stream
      port            = $healthcheckport
      wait            = no
      user            = nobody
      server          = "/usr/sbin/redis-role-$name.sh"
      log_on_failure  += USERID
      disable         = no
      only_from       = 0.0.0.0/0
      per_source      = UNLIMITED
    }

  } 

}
