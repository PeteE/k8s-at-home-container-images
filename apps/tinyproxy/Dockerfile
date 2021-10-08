FROM ghcr.io/k8s-at-home/ubuntu:vfocal-20210723

# set version label
ARG VERSION

COPY ./apps/tinyproxy/script/ /

# Give ourselves root for a bit
USER root

# install supporting software
RUN \
  echo "**** install build packages ****" && \
  apt-get update -qq && \
  apt-get install -qq --no-install-recommends \
    gcc \
    g++ \
    make && \
  echo "**** download tinyproxy ****" && \
  mkdir -p /app/tinyproxy /data && \
  if [ -z ${TINYPROXY_RELEASE} ]; then \
    TINYPROXY_RELEASE=$(curl -sNX GET "https://api.github.com/repos/tinyproxy/tinyproxy/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -No \
    /tmp/tinyproxy.tar.gz -L \
    "https://github.com/tinyproxy/tinyproxy/releases/download/${TINYPROXY_RELEASE}/tinyproxy-${TINYPROXY_RELEASE}.tar.gz" && \
  tar xzvf \
    /tmp/tinyproxy.tar.gz \
    -C /tmp && \
  cd /tmp/tinyproxy-${TINYPROXY_RELEASE} && \
  ./configure && \
  make -s && \
  make -s install && \
  cd /app/tinyproxy && \
  chown -R kah:kah /data /app/tinyproxy && \
  chmod +x /entrypoint.sh

RUN \
  echo "**** cleanup ****" && \
  apt-get remove -qq \
    gcc \
    g++ \
    make && \
  apt-get purge -qq --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
  apt-get autoremove -qq && \
  apt-get clean -qq && \
  rm -rf /tmp/*

# ports and volumes
EXPOSE 8888
USER kah
WORKDIR /app/tinyproxy
CMD [ "/entrypoint.sh" ]
