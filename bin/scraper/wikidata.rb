#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/wikidata_query'

query = <<SPARQL
  SELECT (STRAFTER(STR(?item), STR(wd:)) AS ?wdid) ?name (STRAFTER(STR(?positionItem), STR(wd:)) AS ?pid) ?position
  WHERE {
    BIND (wd:Q101250904 AS ?cabinet) .
    ?cabinet wdt:P31 ?parent .

    # Positions currently in the cabinet
    ?positionItem p:P361 ?ps .
    ?ps ps:P361 ?parent .
    FILTER NOT EXISTS { ?ps pq:P582 [] }

    # Who currently holds those positions
    ?item wdt:P31 wd:Q5 ; p:P39 ?held .
    ?held ps:P39 ?positionItem ; pq:P580 ?start .
    FILTER NOT EXISTS { ?held pq:P582 [] }

    OPTIONAL { ?item rdfs:label ?name FILTER(LANG(?name) = "en") }

    OPTIONAL { ?positionItem wdt:P1705 ?nativeLabel }
    OPTIONAL { ?positionItem rdfs:label ?positionLabel FILTER(LANG(?positionLabel) = "en") }
    BIND(COALESCE(?nativeLabel, ?positionLabel) AS ?position)
  }
  ORDER BY ?positionLabel ?began
SPARQL

agent = 'every-politican-scrapers/sweden-cabinet'
puts EveryPoliticianScraper::WikidataQuery.new(query, agent).csv
