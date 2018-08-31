#!/usr/bin/env bash
set -ex

TEST_TYPE=$1

rm -rf $TEST_TYPE/local/.git
git init $TEST_TYPE/local

rm -rf $TEST_TYPE/remote
mkdir $TEST_TYPE/remote
git init --bare $TEST_TYPE/remote

if [ -z "$REMOTE_PATH" ]; then
  REMOTE_PATH="$(cd "$(dirname "$TEST_TYPE")"; pwd)/$TEST_TYPE/remote"
fi

rm -rf $TEST_TYPE/local.bak
cp -r $TEST_TYPE/local $TEST_TYPE/local.bak

(
  cd $TEST_TYPE/local
  git add .
  git commit -m 'bang'
  git remote add origin "$REMOTE_PATH"
  git push -u origin master
)
