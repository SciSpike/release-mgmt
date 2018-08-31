#!/usr/bin/env bash
set -ex

TEST_TYPE=$1

rm -rf $TEST_TYPE/local
mv $TEST_TYPE/local.bak $TEST_TYPE/local

rm -rf $TEST_TYPE/remote
