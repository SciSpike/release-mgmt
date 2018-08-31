#!/usr/bin/env bash
set -ex

THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"

if [ -n "$TEST_DOCKER" ]; then
  LOCAL_PATH="$THIS_ABSPATH/$1/local"
  export REMOTE_PATH="$THIS_ABSPATH/$1/remote"
  export PREFIX="docker run --rm -i -v $LOCAL_PATH:/gitrepo -v $REMOTE_PATH:$REMOTE_PATH -e EMAIL=fake@scispike.com scispike"
fi

./setup.sh $@
./test-bare.sh $@
./teardown.sh $@
