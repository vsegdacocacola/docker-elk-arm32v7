#!/bin/bash

service elasticsearch start
ES_CONNECT_RETRY=300
ELASTICSEARCH_URL=http://localhost:9200

counter=0
while [ ! "$(curl -k ${ELASTICSEARCH_URL} 2> /dev/null)" -a $counter -lt $ES_CONNECT_RETRY  ]; do
  sleep 1
  ((counter++))
  echo "waiting for Elasticsearch to be up ($counter/$ES_CONNECT_RETRY)"
done
if [ ! "$(curl -k ${ELASTICSEARCH_URL} 2> /dev/null)" ]; then
  echo "Couldn't start Elasticsearch. Exiting."
  echo "Elasticsearch log follows below."
  cat /var/log/elasticsearch/elasticsearch.log
  exit 1
fi

# wait for cluster to respond before getting its name
counter=0
while [ -z "$CLUSTER_NAME" -a $counter -lt 30 ]; do
  sleep 1
  ((counter++))
  CLUSTER_NAME=$(curl -k ${ELASTICSEARCH_URL}/_cat/health?h=cluster 2> /dev/null | tr -d '[:space:]')
  echo "Waiting for Elasticsearch cluster to respond ($counter/30)"
done

if [ -z "$CLUSTER_NAME" ]; then
  echo "Couldn't get name of cluster. Exiting."
  echo "Elasticsearch log follows."
  cat /var/log/elasticsearch/elasticsearch.log
  exit 1
elif [[ "$CLUSTER_NAME" =~ "master_not_discovered_exception" ]]; then
  # If we got a JSON error back, don't treat it like the literal name of the cluster.
  # Example of what this error looks like:
  # [{"error":{"root_cause":[{"type":"master_not_discovered_exception","reason":null}]
  # We don't know the cluster name, so we'll just glob it.
  echo "Failed to contact a healthy master in cluster."
  echo "Elasticsearch logs follow."
  cat /var/log/elasticsearch/*.log
  exit 1
fi
OUTPUT_LOGFILES+="/var/log/elasticsearch/${CLUSTER_NAME}.log "

touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES &
wait