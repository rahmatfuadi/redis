#!/bin/sh
set -e

REDIS_PASSWORD=${REDIS_PASSWORD:-}

create_log_dir() {
  mkdir -p ${REDIS_LOG_DIR}
  chmod -R 0755 ${REDIS_LOG_DIR}
  chown -R ${REDIS_USER}:${REDIS_USER} ${REDIS_LOG_DIR}
}

create_data_dir() {
  mkdir -p ${REDIS_DATA_DIR}
  chmod -R 0755 ${REDIS_DATA_DIR}
  chown -R ${REDIS_USER}:${REDIS_USER} ${REDIS_DATA_DIR}
}

chown_config() {
  chown ${REDIS_USER}:${REDIS_USER} /etc/redis.conf
}

create_log_dir
create_data_dir
chown_config

# allow arguments to be passed to redis-server
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
fi

# default behaviour is to launch redis-server
if [[ -z ${1} ]]; then
  echo "Starting redis-server..."
  exec su-exec ${REDIS_USER}:${REDIS_USER} $(which redis-server) /etc/redis.conf -- \
       ${REDIS_PASSWORD:+--requirepass $REDIS_PASSWORD} ${EXTRA_ARGS}
else
  exec "$@"
fi
