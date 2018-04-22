max_stale = "2m"

template {
  source = "/root/templates/pg.yml.template"
  destination = "/etc/pg.yml"
}

template {
  source = "/root/templates/sys.yml.template"
  destination = "/etc/sys.yml"
}

template {
  source = "/root/templates/redis.yml.template"
  destination = "/etc/redis.yml"
}

template {
  source = "/root/templates/irma.yml.template"
  destination = "/etc/irma/conf.d/irma.yml"
}

exec {
  command = "hypnotoad -f /usr/local/bin/irma.pl"
  splay = "60s"
}
