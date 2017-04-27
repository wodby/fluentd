FROM fluent/fluentd:v0.14-onbuild

ENV GOTPL_VER 0.1.5
ENV GOTPL_URL https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz

USER root

RUN apk add --update \
        sudo \
        build-base \
        ruby-dev \
        ca-certificates \
        wget \
        bash && \

        wget -qO- ${GOTPL_URL} | tar xz -C /usr/local/bin && \

        sudo -u fluent gem install \
            fluent-plugin-kubernetes_metadata_filter \
            fluent-plugin-concat && \

        sudo -u fluent gem sources --clear-all && \
        apk del build-base *-dev && \
        rm -rf /var/cache/apk/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem && \
        rm /fluentd/etc/fluent.conf

USER fluent

COPY fluent.conf.tpl /etc/gotpl/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
