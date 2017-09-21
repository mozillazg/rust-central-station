#!/bin/sh

set -ex

docker pull mozillazg/homu-bot

mkdir -p data/logs/nginx
exec docker run \
  --name homu-bot \
  --volume `pwd`/data:/data \
  --volume `pwd`/data/logs:/var/log \
  --publish 7942:7942 \
  --tty \
  --detach \
  mozillazg/homu-bot
