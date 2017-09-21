#!/bin/bash

set -e

secrets=/data/secrets.toml

# We mounted /var/log from a local log dir, but ubuntu expects it to be owned by
# root:syslog, so change it here
chown root:syslog /var/log
touch /var/log/cron.log

# Background daemons we use here
/usr/sbin/rsyslogd
cron

export RUST_BACKTRACE=1

set -ex


# Configure/run nginx
# rbars $secrets /src/nginx.conf.template > /tmp/nginx.conf
# nginx -c /tmp/nginx.conf

# Configure and run homu
rbars $secrets /src/homu.toml.template > /tmp/homu.toml
homu -v -c /tmp/homu.toml 2>&1
