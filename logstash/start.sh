#!/bin/bash

service logstash start
OUTPUT_LOGFILES+="/var/log/logstash/logstash-plain.log"

touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES &
wait