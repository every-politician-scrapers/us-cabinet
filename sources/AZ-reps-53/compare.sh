#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb $(jq -r .source meta.json) > scraped.csv
wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv search -s startDate . > wikidata.csv
bundle exec ruby diff.rb | qsv sort -s itemlabel | qsv select 1,3,2,4,5 | tee diff.csv

cd ~-
