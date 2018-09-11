#!/usr/bin/env bash
set -e

TEST_TYPE=$1

THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"

rm -rf "$THIS_ABSPATH/$TEST_TYPE/local/.git"
git init "$THIS_ABSPATH/$TEST_TYPE/local"

rm -rf "$THIS_ABSPATH/$TEST_TYPE/remote"
mkdir -p "$THIS_ABSPATH/$TEST_TYPE/remote"
git init --bare "$THIS_ABSPATH/$TEST_TYPE/remote"

if [ -z "$REMOTE_PATH" ]; then
  REMOTE_PATH="$(cd "$(dirname "$THIS_ABSPATH/$TEST_TYPE")"; pwd)/$TEST_TYPE/remote"
fi

rm -rf "$THIS_ABSPATH/$TEST_TYPE/local.bak"
cp -r "$THIS_ABSPATH/$TEST_TYPE/local" "$THIS_ABSPATH/$TEST_TYPE/local.bak"

(
  cd "$THIS_ABSPATH/$TEST_TYPE/local"
  git add .
  git commit -m 'bang'
  git remote add origin "$REMOTE_PATH"
  git push -u origin master
)
