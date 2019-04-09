#!/usr/bin/env bash

if [ -d /root/.ssh ]; then
  chmod 700 /root/.ssh
fi
if [ -f /root/.ssh/id_rsa ]; then
  chmod 600 /root/.ssh/id_rsa
fi
if [ -f /root/.ssh/id_rsa.pub ]; then
  chmod 644 /root/.ssh/id_rsa.pub
fi

/scripts/release $@
