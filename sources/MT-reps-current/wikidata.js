const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = function () {
  return `SELECT DISTINCT ?item ?itemLabel ?startDate ?endDate (STRAFTER(STR(?ps), STR(wds:)) AS ?psid)
    WITH {
      SELECT DISTINCT ?item ?position ?startNode ?endNode ?ps
      WHERE {
          ?item wdt:P31 wd:Q5 ; p:P39 ?ps .
          ?ps ps:P39 ?position .
          ?position wdt:P279* wd:${meta.position} .
          FILTER NOT EXISTS { ?ps wikibase:rank wikibase:DeprecatedRank }
          OPTIONAL { ?item p:P570 [ a wikibase:BestRank ; psv:P570 ?dod ] }
          OPTIONAL { ?ps pqv:P580 ?p39start }
          MINUS { ?ps pq:P582 ?p39end }
          OPTIONAL {
            ?ps pq:P2937 ?term .
            OPTIONAL { ?term p:P571 [ a wikibase:BestRank ; psv:P571 ?termInception ] }
            OPTIONAL { ?term p:P580 [ a wikibase:BestRank ; psv:P580 ?termStart ] }
            OPTIONAL { ?term p:P576 [ a wikibase:BestRank ; psv:P576 ?termAbolished ] }
            OPTIONAL { ?term p:P582 [ a wikibase:BestRank ; psv:P582 ?termEnd ] }
          }
          wd:Q18354756 p:P580/psv:P580 ?farFuture .

          BIND(COALESCE(?p39start, ?termInception, ?termStart) AS ?startNode)
          FILTER(BOUND(?startNode))
      }
    } AS %statements
    WHERE {
      INCLUDE %statements .
      ?startNode wikibase:timeValue ?startV ; wikibase:timePrecision ?startP .

      BIND (
        COALESCE(
          IF(?startP = 11, SUBSTR(STR(?startV), 1, 10), 1/0),
          IF(?startP = 10, SUBSTR(STR(?startV), 1, 7), 1/0),
          IF(?startP = 9,  SUBSTR(STR(?startV), 1, 4), 1/0),
          IF(?startP = 8,  CONCAT(SUBSTR(STR(?startV), 1, 4), "s"), 1/0),
          ""
        ) AS ?startDate
      )

      SERVICE wikibase:label { bd:serviceParam wikibase:language "${meta.lang}". }
    }
    # ${new Date().toISOString()}
    ORDER BY ?start ?end ?item ?psid`
}
