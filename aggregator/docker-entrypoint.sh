#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
  set -x
fi

gotpl '/etc/gotpl/td-agent.conf.tpl' > '/etc/td-agent/td-agent.conf'

exec td-agent $@
