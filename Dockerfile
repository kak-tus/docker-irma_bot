FROM debian:9

ENV CONSUL_TEMPLATE_VERSION=0.18.5
ENV CONSUL_TEMPLATE_SHA256=b0cd6e821d6150c9a0166681072c12e906ed549ef4588f73ed58c9d834295cd2

RUN \
  apt-get update \

  && apt-get install --no-install-recommends --no-install-suggests -y \
    build-essential \
    cpanminus \
    curl \
    git \
    libextutils-makemaker-cpanfile-perl \
    unzip \

  && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
    libanyevent-perl \
    libclass-xsaccessor-perl \
    libcpanel-json-xs-perl \
    libdbd-pg-perl \
    libev-perl \
    libhash-merge-perl \
    libio-socket-ssl-perl \
    libmodule-build-tiny-perl \
    libmoo-perl \
    libparams-validate-perl \
    libpq5 \
    libsql-abstract-perl \
    libtest-compile-perl \
    libtest-fatal-perl \
    libtest-tcp-perl \
    libtext-trim-perl \
    liburi-perl \
    libyaml-libyaml-perl \

  && cd /usr/local/bin \
  && curl -L https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && echo -n "$CONSUL_TEMPLATE_SHA256  consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" | sha256sum -c - \
  && unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \

  && cpanm https://github.com/kak-tus/irma_bot.git@0.9 \

  && apt-get purge -y --auto-remove \
    build-essential \
    cpanminus \
    curl \
    git \
    libextutils-makemaker-cpanfile-perl \
    libpq-dev \
    unzip \

  && rm -rf /var/lib/apt/lists/*

EXPOSE 9000

ENV SET_CONTAINER_TIMEZONE=true
ENV CONTAINER_TIMEZONE=Europe/Moscow

ENV USER_UID=1000
ENV USER_GID=1000

ENV CONSUL_HTTP_ADDR=
ENV CONSUL_TOKEN=
ENV VAULT_ADDR=
ENV VAULT_TOKEN=

ENV IRMA_NOTIFY_URL=
ENV IRMA_MODE=development
ENV IRMA_BOT_NAME=irma_bot

ENV IRMA_DB=
ENV IRMA_DB_PORT=

ENV REDIS_ADDR=
ENV REDIS_PORT=

COPY pg.yml.template /root/pg.yml.template
COPY sys.yml.template /root/sys.yml.template
COPY service.hcl /etc/service.hcl
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY irma.yml.template /root/irma.yml.template
COPY redis.yml.template /root/redis.yml.template

CMD ["/usr/local/bin/entrypoint.sh"]
