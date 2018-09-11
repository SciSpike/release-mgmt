#!/usr/bin/env bash
set -e

TEST_TYPE=$1

THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"

rm -rf "$THIS_ABSPATH/$TEST_TYPE/local"
mv "$THIS_ABSPATH/$TEST_TYPE/local.bak" "$THIS_ABSPATH/$TEST_TYPE/local"

rm -rf "$THIS_ABSPATH/$TEST_TYPE/remote"
