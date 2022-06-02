#!/bin/bash

bundle exec ruby scraper.rb $(jq -r .source meta.json) > scraped.csv
wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s startDate > wikidata.csv
[ -s wikidata.csv ] || (echo "item,itemLabel,startDate,endDate,sourceDate,psid" > wikidata.csv)
bundle exec ruby diff.rb | qsv sort -s startdate | tee diff.csv
