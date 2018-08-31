#!/usr/bin/env bash
set -e

if [[ "$1" =~ ^(--?)?h(elp)?$ ]] || [[ $# -lt 1 ]]; then
  echo "usage: $0 [string] pattern"
  echo "[string] is optional if piping from stdin"
  echo "if you don't want a space as the delimiter, set the environment variable MATCH_DELIM"
  echo "capture groups 1 through n are written to stdout"
  exit 2
fi

if [[ $# == 1 ]]; then # read from stdin
  pattern="$1"
  read
  value="$REPLY"
else
  pattern="$2"
  value="$1"
fi

delim=${MATCH_DELIM:-' '}

if [[ "$value" =~ $pattern ]]; then
  i=1
  n=${#BASH_REMATCH[*]}

  while [[ $i -le $n ]]; do
    if [ "$matches" == "" ]; then
      matches="${BASH_REMATCH[$i]}"
    else
      matches="$matches$delim${BASH_REMATCH[$i]}"
    fi
    let i++
  done
  if [ "$matches" != "" ]; then
    echo "$matches"
  fi
  exit 0
else
  exit 1
fi
