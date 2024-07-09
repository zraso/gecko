require 'httparty'
require 'sparql'

class DbpediaRequest
    DBPEDIA_SPARQL = 'http://dbpedia.org/sparql'

    def self.find_films_by_actor(actor)
        puts "Executing query_films_by_actor with actor: #{actor}"
        query = <<-SPARQL
          SELECT ?film WHERE {
            ?film rdf:type dbo:Film .
            ?film dbo:starring dbr:#{actor} .
          }
        SPARQL
    
        run_query(query, 'film')
      end

    def self.run_query(query, variable)
        response = HTTParty.get(DBPEDIA_SPARQL, query: { query: query, format: 'json'})
        return [] unless response.success?

        results = JSON.parse(response.body)['results']['bindings']
        results.map { |result| result[variable]['value'].split('/').last.gsub('-', ' ') }
    end
end