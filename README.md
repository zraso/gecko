# Installation

# Process
1. Set up
2. Break down tests
3. Seperate dbpedia_query so that if we need to add more queries later, can do this and import easily

# Tests

* Linux or Mac
* WEb browser or cURL
* a single endpoint
- either 'actor' or 'film'
    curl localhost:9292?actor=Macaulay_Culkin
    curl localhost:9292?film=Hellraiser
* DBpedia
- Only queries once for the same query, during one session. Otherwise, it should store it. Maybe key / value store?
* SPARQL