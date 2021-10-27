#!/bin/bash

indices=$(curl -s -o - http://localhost:9200/_cat/indices | awk ' $3 ~ "core" {print $3}')

index_patterns=$(curl -s -o - -X GET -H 'Content-Type: application/json' -H 'kbn-xsrf: true' http://localhost:5601/api/saved_objects/_find?type=index-pattern)

for i in ${indices}; do
  if  echo ${index_patterns} | grep -qvw ${i} ; then
    status_code=$(curl --write-out '%{http_code}' --silent --output /dev/null -X POST -H 'Content-Type: application/json' -H 'kbn-xsrf: true' http://localhost:5601/api/index_patterns/index_pattern -d "{\"index_pattern\": {\"id\": \"$i\", \"title\": \"$i\", \"timeFieldName\": \"time\"}}")
    if [[ "$status_code" -ne 200 ]] ; then
        echo "Error $status_code creating index pattern $i"
    else
        echo "Created index pattern $i"
    sleep 1
    fi
  fi
done
