#!/usr/bin/env bash
set -ex

THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"
TYPES=${@:-nodejs chart version image image-codefresh}

for type in $TYPES; do
  export TEST_DOCKER=
  "$THIS_ABSPATH/test.sh" $type

  export TEST_DOCKER=1
  "$THIS_ABSPATH/test.sh" $type
done
