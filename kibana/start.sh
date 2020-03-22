#!/bin/bash

service kibana start
OUTPUT_LOGFILES+="/var/log/kibana/kibana.log "

touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES &
wait