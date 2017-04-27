<match fluent.**>
  @type null
</match>

# Example:
# {"log":"[info:2016-02-16T16:04:05.930-08:00] Some log text here\n","stream":"stdout","time":"2016-02-17T00:04:05.931087621Z"}
<source>
  @type tail
  path /var/log/containers/*.log
  pos_file /var/log/es-containers.log.pos
  time_format %Y-%m-%dT%H:%M:%S.%NZ
  tag exceptions.kubernetes.*
  format json
  read_from_head true
</source>

# Example:
# 2015-12-21 23:17:22,066 [salt.state       ][INFO    ] Completed state [net.ipv4.ip_forward] at time 23:17:22.066081
<source>
  @type tail
  format /^(?<time>[^ ]* [^ ,]*)[^\[]*\[[^\]]*\]\[(?<severity>[^ \]]*) *\] (?<message>.*)$/
  time_format %Y-%m-%d %H:%M:%S
  path /var/log/salt/minion
  pos_file /var/log/es-salt.pos
  tag salt
</source>

# Example:
# Dec 21 23:17:22 gke-foo-1-1-4b5cbd14-node-4eoj startupscript: Finished running startup script /var/run/google.startup.script
<source>
  @type tail
  format syslog
  path /var/log/startupscript.log
  pos_file /var/log/es-startupscript.log.pos
  tag startupscript
</source>

# Examples:
# time="2016-02-04T06:51:03.053580605Z" level=info msg="GET /containers/json"
# time="2016-02-04T07:53:57.505612354Z" level=error msg="HTTP Error" err="No such image: -f" statusCode=404
<source>
  @type tail
  format /^time="(?<time>[^)]*)" level=(?<severity>[^ ]*) msg="(?<message>[^"]*)"( err="(?<error>[^"]*)")?( statusCode=($<status_code>\d+))?/
  path /var/log/docker.log
  pos_file /var/log/es-docker.log.pos
  tag docker
</source>

# Example:
# 2016/02/04 06:52:38 filePurge: successfully removed file /var/etcd/data/member/wal/00000000000006d0-00000000010a23d1.wal
<source>
  @type tail
  # Not parsing this, because it doesn't have anything particularly useful to
  # parse out of it (like severities).
  format none
  path /var/log/etcd.log
  pos_file /var/log/es-etcd.log.pos
  tag etcd
</source>

# Multi-line parsing is required for all the kube logs because very large log
# statements, such as those that include entire object bodies, get split into
# multiple lines by glog.

# Example:
# I0204 07:32:30.020537    3368 server.go:1048] POST /stats/container/: (13.972191ms) 200 [[Go-http-client/1.1] 10.244.1.3:40537]
<source>
  @type tail
  format multiline
  multiline_flush_interval 5s
  format_firstline /^\w\d{4}/
  format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
  time_format %m%d %H:%M:%S.%N
  path /var/log/kubelet.log
  pos_file /var/log/es-kubelet.log.pos
  tag kubelet
</source>

# Example:
# I1118 21:26:53.975789       6 proxier.go:1096] Port "nodePort for kube-system/default-http-backend:http" (:31429/tcp) was open before and is still needed
<source>
  @type tail
  format multiline
  multiline_flush_interval 5s
  format_firstline /^\w\d{4}/
  format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
  time_format %m%d %H:%M:%S.%N
  path /var/log/kube-proxy.log
  pos_file /var/log/es-kube-proxy.log.pos
  tag kube-proxy
</source>

# Example:
# I0204 07:00:19.604280       5 handlers.go:131] GET /api/v1/nodes: (1.624207ms) 200 [[kube-controller-manager/v1.1.3 (linux/amd64) kubernetes/6a81b50] 127.0.0.1:38266]
<source>
  @type tail
  format multiline
  multiline_flush_interval 5s
  format_firstline /^\w\d{4}/
  format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
  time_format %m%d %H:%M:%S.%N
  path /var/log/kube-apiserver.log
  pos_file /var/log/es-kube-apiserver.log.pos
  tag kube-apiserver
</source>

# Example:
# I0204 06:55:31.872680       5 servicecontroller.go:277] LB already exists and doesn't need update for service kube-system/kube-ui
<source>
  @type tail
  format multiline
  multiline_flush_interval 5s
  format_firstline /^\w\d{4}/
  format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
  time_format %m%d %H:%M:%S.%N
  path /var/log/kube-controller-manager.log
  pos_file /var/log/es-kube-controller-manager.log.pos
  tag kube-controller-manager
</source>

# Example:
# W0204 06:49:18.239674       7 reflector.go:245] pkg/scheduler/factory/factory.go:193: watch of *api.Service ended with: 401: The event in requested index is outdated and cleared (the requested history has been cleared [2578313/2577886]) [2579312]
<source>
  @type tail
  format multiline
  multiline_flush_interval 5s
  format_firstline /^\w\d{4}/
  format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
  time_format %m%d %H:%M:%S.%N
  path /var/log/kube-scheduler.log
  pos_file /var/log/es-kube-scheduler.log.pos
  tag kube-scheduler
</source>

# Example:
# I1104 10:36:20.242766       5 rescheduler.go:73] Running Rescheduler
<source>
  @type tail
  format multiline
  multiline_flush_interval 5s
  format_firstline /^\w\d{4}/
  format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
  time_format %m%d %H:%M:%S.%N
  path /var/log/rescheduler.log
  pos_file /var/log/es-rescheduler.log.pos
  tag rescheduler
</source>

# Example:
# I0603 15:31:05.793605       6 cluster_manager.go:230] Reading config from path /etc/gce.conf
<source>
  @type tail
  format multiline
  multiline_flush_interval 5s
  format_firstline /^\w\d{4}/
  format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
  time_format %m%d %H:%M:%S.%N
  path /var/log/glbc.log
  pos_file /var/log/es-glbc.log.pos
  tag glbc
</source>

# Example:
# I0603 15:31:05.793605       6 cluster_manager.go:230] Reading config from path /etc/gce.conf
<source>
  @type tail
  format multiline
  multiline_flush_interval 5s
  format_firstline /^\w\d{4}/
  format1 /^(?<severity>\w)(?<time>\d{4} [^\s]*)\s+(?<pid>\d+)\s+(?<source>[^ \]]+)\] (?<message>.*)/
  time_format %m%d %H:%M:%S.%N
  path /var/log/cluster-autoscaler.log
  pos_file /var/log/es-cluster-autoscaler.log.pos
  tag cluster-autoscaler
</source>

# Uncomment in a case of daemon-set usage
<filter exceptions.kubernetes.**>
  @type kubernetes_metadata
</filter>

# Custom config begin

# <filter kubernetes.**>
#   @@type record_transformer
#   auto_typecast true

#   <record>
#     application ${kubernetes["namespace_name"]}
#     service ${kubernetes["container_name"]}
#     replica ${kubernetes["pod_name"]}
#     server ${kubernetes["host"]}
#   </record>
# </filter>

# <filter kubernetes.var.log.containers.web-backend-**>
#   @type concat
#   key log
#   log_level error
#   multiline_start_regexp /^.+/
#   flush_interval 1s
# </filter>

# <filter kubernetes.var.log.containers.web-backend-**>
#   @type concat
#   key log
#   log_level error
#   multiline_start_regexp /PHP (?:Notice|Parse error|Fatal error|Warning):/
#   # multiline_end_regexp /on line \d+/
#   use_first_timestamp true
#   flush_interval 1s
# </filter>

# <match kubernetes.var.log.containers.**>
#   @type rewrite
#   remove_prefix kubernetes
#   add_prefix exceptions
#   # <rule>
#   #   key     log
#   #   pattern $\n
#   #   replace
#   # </rule>
# </match>

#<match exceptions.kubernetes.var.log.containers.**>
#  @type detect_exceptions
#  message log
#  languages php
#  remove_tag_prefix exceptions
#  multiline_flush_interval 1
#</match>

# <match exceptions.kubernetes.var.log.containers.**>
#   @type null
# </match>

<match kubernetes.var.log.containers.*_logging_**>
  @type null
</match>

<match kubernetes.var.log.containers.*_monitoring_**>
  @type null
</match>

<match kubernetes.var.log.containers.*_kube-system_**>
  @type null
</match>

<match kubernetes.var.log.containers.*_wodby_**>
  @type null
</match>

# Custom config end

<match **>
  @id {{ getenv "FLUENTD_ID" "WODBY_FORWARDER" }}
  @type forward

  transport tls
  tls_cert_path /fluentd/etc/cert.pem
  tls_allow_self_signed_cert true

  <server>
    host {{ getenv "FLUENTD_AGGREGATOR_HOST" "example.com" }}
    port {{ getenv "FLUENTD_AGGREGATOR_PORT" "24228" }}
  </server>
</match>
