#!/usr/bin/env bash
set -ex

TEST_TYPE=$1
THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"

SCRIPT=${SCRIPT:-release}
PREFIX=${PREFIX:-$THIS_ABSPATH/..}

# set to empty string to disable
export RELEASE_DEBUG=1

# TODO: assertions & test saddy paths

(
  cd "$THIS_ABSPATH/$TEST_TYPE/local"

  echo 'TEST: 1 pre'
  $PREFIX/$SCRIPT $TEST_TYPE pre

  echo 'TEST: 2 rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc

  echo 'TEST: 3 rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc

  echo 'TEST: 4 minor'
  $PREFIX/$SCRIPT $TEST_TYPE minor

  echo 'TEST: 5 rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc

  echo 'TEST: 6 patch'
  $PREFIX/$SCRIPT $TEST_TYPE patch

  echo 'TEST: 7 rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc

  git checkout master

  echo 'TEST: 8 pre'
  $PREFIX/$SCRIPT $TEST_TYPE pre

  echo 'TEST: 9 rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc
)
