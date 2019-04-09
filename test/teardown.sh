#!/usr/bin/env bash
set -ex

TEST_TYPE="$1"

THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"

rm -rf \
  "$THIS_ABSPATH/$TEST_TYPE/local" \
  "$THIS_ABSPATH/$TEST_TYPE/remote"
