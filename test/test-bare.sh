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

  echo 'TEST: pre'
  $PREFIX/$SCRIPT $TEST_TYPE pre

  echo 'TEST: rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc

  echo 'TEST: rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc

  echo 'TEST: minor'
  $PREFIX/$SCRIPT $TEST_TYPE minor

  echo 'TEST: rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc

  echo 'TEST: patch'
  $PREFIX/$SCRIPT $TEST_TYPE patch

  echo 'TEST: rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc

  git checkout master

  echo 'TEST: pre'
  $PREFIX/$SCRIPT $TEST_TYPE pre

  echo 'TEST: rc'
  $PREFIX/$SCRIPT $TEST_TYPE rc
)
