<match fluent.**>
  type null
</match>

<source>
  @id {{ getenv "FLUENTD_ID" "WODBY_AGGREGATOR" }}
  @type forward
  port 24228

  <transport tls>
    # version TLSv1_2
    cert_path              /fluentd/etc/ca.pem
    private_key_path       /fluentd/etc/ca-key.pem
  </transport>
</source>

# Custom config end

<match **>
   type {{ getenv "FLUENTD_DESTINATION_TYPE" "elasticsearch" }}
   log_level info
   include_tag_key true
   host {{ getenv "FLUENTD_DESTINATION_HOST" "elasticsearch" }}
   port {{ getenv "FLUENTD_DESTINATION_PORT" "9200" }}
   logstash_format true
   # Set the chunk limit the same as for fluentd-gcp.
   buffer_chunk_limit 2M
   # Cap buffer memory usage to 2MiB/chunk * 32 chunks = 64 MiB
   buffer_queue_limit 32
   flush_interval 5s
   # Never wait longer than 5 minutes between retries.
   max_retry_wait 30
   # Disable the limit on the number of retries (retry forever).
   disable_retry_limit
   # Use multiple threads for processing.
   num_threads 8
   # Specify indices template
   # template_name logstash
   # template_file /etc/elasticsearch-template.json
</match>
