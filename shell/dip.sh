#!/bin/sh

# DIP

outter_ip=$1
outter_port=$2
inner_ip=$3
inner_port=$4
protocol=$5

logger -t "DIP" "[DIP] start : ${protocol}: ${outter_ip}:${outter_port} to ${inner_ip}:${inner_port}"

if [ "${outter_port}" ]; then
  logger -t "DIP" "${outter_ip}:${outter_port}"
  curl -Ss -o /dev/null -X POST \
    -H 'Content-Type: application/json' \
    -d '{"ip": "'"${outter_ip}"'", "port": "'"${outter_port}"'", "key": "'"${inner_port}"'"}' \
    "https://magic.miantiao.me/dip"
fi

logger -t "DIP" "[DIP] ${inner_port} end"