#!/bin/bash
#Create index
curl -X PUT "localhost:9200/autocomplete?pretty" -H 'Content-Type: application/json' --data-binary @./queries/settings.json

#Convert data
input="./dictionary/popular.txt"
while IFS= read -r line; do
  echo "{\"index\" :{}}"
  echo "{ \"word\" : \"$line\"}"
done <"$input" >>./dictionary/popular.json

#Populate data
curl -X POST "localhost:9200/autocomplete/_bulk?pretty" -H 'Content-Type: application/json' --data-binary @./dictionary/popular.json
