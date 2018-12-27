#!/usr/bin/env bash
set -ex

THIS_ABSPATH="$(cd "$(dirname "$0")"; pwd)"
TYPE=$1

if [ -n "$TEST_DOCKER" ]; then
  LOCAL_PATH="$THIS_ABSPATH/$TYPE/local"
  export REMOTE_PATH="$THIS_ABSPATH/$TYPE/remote"
  export PREFIX="docker run --rm -i -v $LOCAL_PATH:/gitrepo -v $REMOTE_PATH:$REMOTE_PATH -e EMAIL=fake@scispike.com -e GIT_AUTHOR_NAME=$USER -e GIT_COMMITTER_NAME=$USER scispike"

  docker build --tag scispike/release-$TYPE -f "$THIS_ABSPATH/../$TYPE.Dockerfile" "$THIS_ABSPATH/.."
fi

"$THIS_ABSPATH/setup.sh" $@
"$THIS_ABSPATH/test-bare.sh" $@
"$THIS_ABSPATH/teardown.sh" $@
