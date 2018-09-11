#!/usr/bin/env bash
set -e

TEST_TYPE=$1
THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"

SCRIPT=${SCRIPT:-release-$TEST_TYPE}
PREFIX=${PREFIX:-$THIS_ABSPATH/..}

# set to empty string to disable
export RELEASE_DEBUG=1

# TODO: assertions & test saddy paths

(
  cd "$THIS_ABSPATH/$TEST_TYPE/local"

  set -x

  $PREFIX/$SCRIPT pre

  $PREFIX/$SCRIPT rc

  $PREFIX/$SCRIPT rc

  $PREFIX/$SCRIPT minor

  $PREFIX/$SCRIPT rc

  $PREFIX/$SCRIPT patch

  $PREFIX/$SCRIPT rc

  git checkout master

  $PREFIX/$SCRIPT pre

  $PREFIX/$SCRIPT rc
)
