#
# IoTc - Internet of Things controller
#
FROM msaraiva/elixir-dev:latest
MAINTAINER Marc Zimmermann "tooreht@gmail.com"

ENV REFRESHED_AT=2016-06-21 \
    BUILD_DIR=/tmp/iotc \
    APP_DIR=/opt/iotc \
    APP_VERSION=0.1.0 \
    MIX_ENV=prod \
    TERM=xterm \
    REPLACE_OS_VARS=true

EXPOSE 1700:1700/udp
EXPOSE 4369:4369
EXPOSE 4242:4242

WORKDIR ${BUILD_DIR}
COPY . .
RUN mix do deps.get, deps.compile, compile, release.init, release --verbose --env=prod

WORKDIR ${APP_DIR}
RUN tar -xzf ${BUILD_DIR}/rel/iotc/releases/$APP_VERSION/iotc.tar.gz -C ${APP_DIR} && \
    chmod -R 777 ${APP_DIR} && \
    rm -rf ${BUILD_DIR}

ENTRYPOINT ["./bin/iotc"]
CMD ["foreground"]



# WITHOUT DISTILLERY

# RUN mix do deps.get, mix compile

# ENTRYPOINT ["iex"]
# CMD ["--name", "iotc@10.0.0.159", "--cookie", "monster", "--erl", "'-kernel inet_dist_listen_min 4242 inet_dist_listen_max 4242'", "-S", "mix"]
