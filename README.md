# Installation

# Process
1. Set up
2. Break down tests

# Tests

* Linux or Mac
* WEb browser or cURL
* a single endpoint
- either 'actor' or 'film'
    curl localhost:9292?actor=Macaulay_Culkin
    curl localhost:9292?film=Hellraiser
* JSON-formatted data
* DBpedia
- Only queries once for the same query, during one session. Otherwise, it should store it. Maybe key / value store?
* SPARQL