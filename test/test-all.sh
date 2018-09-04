#!/usr/bin/env bash
set -ex

THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"

for type in nodejs chart image-codefresh version; do
  export TEST_DOCKER=
  "$THIS_ABSPATH/test.sh" $type

  docker build --tag scispike/release-$type -f "$THIS_ABSPATH/../$type.Dockerfile" "$THIS_ABSPATH/.."

  export TEST_DOCKER=1
  "$THIS_ABSPATH/test.sh" $type
done
