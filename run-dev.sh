#!/bin/sh

set -ex

docker build \
  --tag homu-bot \
  --rm \
  .

exec docker run \
  --name homu-bot \
  --volume `pwd`/data:/data \
  --env DEV=1 \
  --publish 7942:7942 \
  --detach \
  homu-bot \
