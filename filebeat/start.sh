#!/bin/bash

service filebeat start
OUTPUT_LOGFILES+="/var/log/filebeat"

touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES &
wait