#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
  set -x
fi

gotpl '/etc/gotpl/fluent.conf.tpl' > '/fluentd/etc/fluent.conf'

if [[ -z $@ ]]; then
    exec fluentd -c "/fluentd/etc/${FLUENTD_CONF}" -p /fluentd/plugins "${FLUENTD_OPT}"
else
    exec $@
fi
