#!/usr/bin/env bash
set -ex

TEST_TYPE=$1
SCRIPT=${SCRIPT:-release-$TEST_TYPE}
PREFIX=${PREFIX:-../../..}

# set to empty string to disable
export RELEASE_DEBUG=1

# TODO: assertions & test saddy paths

(
  cd $TEST_TYPE/local

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
