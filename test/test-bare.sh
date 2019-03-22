#!/usr/bin/env bash
set -e

TEST_TYPE=$1
THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"

SCRIPT=${SCRIPT:-release}
PREFIX=${PREFIX:-$THIS_ABSPATH/..}

# set to empty string to disable
export RELEASE_DEBUG=1

# TODO: assertions & test saddy paths

(
  cd "$THIS_ABSPATH/$TEST_TYPE/local"

  $PREFIX/$SCRIPT $TEST_TYPE pre

  $PREFIX/$SCRIPT $TEST_TYPE rc

  $PREFIX/$SCRIPT $TEST_TYPE rc

  $PREFIX/$SCRIPT $TEST_TYPE minor

  $PREFIX/$SCRIPT $TEST_TYPE rc

  $PREFIX/$SCRIPT $TEST_TYPE patch

  $PREFIX/$SCRIPT $TEST_TYPE rc

  git checkout master

  $PREFIX/$SCRIPT $TEST_TYPE pre

  $PREFIX/$SCRIPT $TEST_TYPE rc
)
