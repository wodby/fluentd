#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
  set -x
fi

gotpl "/etc/gotpl/fluent.conf.tpl" > "/fluentd/etc/${FLUENTD_CONF}"

if [[ -z $@ ]]; then
    exec fluentd -c "/fluentd/etc/${FLUENTD_CONF}"
else
    exec $@
fi
