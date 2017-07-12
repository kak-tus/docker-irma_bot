FROM debian:9

RUN \
  apt-get update \

  && apt-get install --no-install-recommends --no-install-suggests -y \
    build-essential \
    cpanminus \
    libpq-dev \

  && apt-get install --no-install-recommends --no-install-suggests -y \
    libpq5 \
    libio-socket-ssl-perl

  # && cpanm https://github.com/kak-tus/irma_bot.git@0.1

EXPOSE 9000

ENV USER_UID=1000
ENV USER_GID=1000

ENV IRMA_API_KEY_PROD=
ENV IRMA_API_KEY_DEV=

ENV IRMA_NOTIFY_KEY_PROD=
ENV IRMA_NOTIFY_KEY_DEV=

ENV IRMA_NOTIFY_URL=
