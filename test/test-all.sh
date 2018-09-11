#!/usr/bin/env bash
set -e

THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"
TYPES=${@:-nodejs chart version image image-codefresh}

for type in $TYPES; do
  echo '########################'
  echo testing type $type
  echo '########################'

  export TEST_DOCKER=
  "$THIS_ABSPATH/test.sh" $type

  echo '########################'
  echo testing type $type using docker
  echo '########################'

  export TEST_DOCKER=1
  "$THIS_ABSPATH/test.sh" $type
done
