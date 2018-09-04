#!/usr/bin/env bash
set -ex

for type in nodejs chart image-codefresh version; do
  export TEST_DOCKER=
  ./test.sh $type

  docker build --tag scispike/release-$type -f ../docker/$type.Dockerfile ..

  export TEST_DOCKER=1
  ./test.sh $type
done
