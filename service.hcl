max_stale = "2m"

template {
  source = "/root/pg.yml.template"
  destination = "/etc/pg.yml"
}

template {
  source = "/root/sys.yml.template"
  destination = "/etc/sys.yml"
}

template {
  source = "/root/irma.yml.template"
  destination = "/etc/irma/conf.d/irma.yml"
}

exec {
  command = ""
  splay = "60s"
}
