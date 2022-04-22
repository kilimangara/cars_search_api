#!/usr/bin/env bash

PRIMARY_CONTAINER="app:3000"

if ! bundle check; then
  echo "Bundle not ready, waiting for it to be completed by container $PRIMARY_CONTAINER"
  $(dirname $(realpath $0))/wait-for-it.sh $PRIMARY_CONTAINER -t 0
fi
