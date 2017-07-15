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
    libpq-dev \
    unzip \

  && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
    libio-socket-ssl-perl \
    libpq5 \

  && cd /usr/local/bin \
  && curl -L https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && echo -n "$CONSUL_TEMPLATE_SHA256  consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" | sha256sum -c - \
  && unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \

  && cpanm https://github.com/kak-tus/irma_bot.git@0.1 \

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

ENV IRMA_DB=
ENV IRMA_DB_PORT=

COPY pg.yml.template /root/pg.yml.template
COPY sys.yml.template /root/sys.yml.template
COPY service.hcl /etc/service.hcl
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY irma.yml.template /root/irma.yml.template

CMD ["/usr/local/bin/entrypoint.sh"]
