FROM gcr.io/google_containers/ubuntu-slim:0.4

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive
ENV LD_PRELOAD /opt/td-agent/embedded/lib/libjemalloc.so
ENV GOTPL_VER 0.1.5

# Ensure there are enough file descriptors for running Fluentd.
RUN ulimit -n 65536 && \

    # Download and install Gotpl
    wget -qO- https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz | tar xz -C /usr/local/bin && \

# Copy the Fluentd configuration file.
COPY td-agent.conf.tpl /etc/gotpl/

COPY build.sh /tmp/build.sh
COPY fluent-plugin-detect-exceptions-0.0.4.gem /tmp/fluent-plugin-detect-exceptions-0.0.4.gem
RUN /tmp/build.sh

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
