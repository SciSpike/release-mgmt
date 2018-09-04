#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2018 SciSpike, LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# This provides a portable regular expression capability based on bash's regex matching operator, =~

set -e

arg=${1:-$2}
if [[ "$arg" =~ ^(--?)?h(e(l(p)?)?)?$ ]] || [[ $# -lt 1 ]]; then
  echo "usage: $0 pattern [string]"
  echo "* [string] is optional if piping from stdin, else it's required"
  echo "* if you don't want a space as the delimiter, set the environment variable MATCH_DELIM"
  echo "* capture groups 0 (entire matched string) through n are written to stdout"
  echo "* exits with 0 if matched, nonzero otherwise"
  exit 2
fi

pattern="$1"

if [[ $# == 1 ]]; then # read from stdin
  read
  value="$REPLY"
else
  value="$2"
fi

delim=${MATCH_DELIM:-' '}

if [[ "$value" =~ $pattern ]]; then
  i=0
  n=$((${#BASH_REMATCH[*]}-1))

  while [[ $i -le $n ]]; do
    matches="$matches${BASH_REMATCH[$i]}"
    if [ $i -ne $n ]; then
      matches="$matches$delim"
    fi
    i=$(($i+1))
  done
  if [ -n "$matches" ]; then
    echo "$matches"
  fi
  exit 0
else
  exit 1
fi
