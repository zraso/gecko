require 'rspec'
require 'rack/test'
require_relative '../app'

ENV['RACK_ENV'] = 'test'

RSpec.describe 'Dbpedia Request' do

	it "finds film by actor" do
		response = {
			"results" => {
				"bindings" => [
					{ "film" => { "value" => "http://dbpedia.org/resource/Forrest_Gump" }},
					{ "film" => { "value" => "http://dbpedia.org/resource/Cast_Away" }}
				]
			}
		}

		allow(HTTParty).to receive(:get).and_return(double(success?: true, body: response.to_json))
		result = DbpediaRequest.find_films_by_actor("Tom_Hanks")
		expect(result).to eq(["Forrest_Gump", "Cast_Away"])
	end

	it "finds actors by film" do
		response = {
      "results" => {
        "bindings" => [
          { "actor" => { "value" => "http://dbpedia.org/resource/Ashley_Laurence" }},
          { "actor" => { "value" => "http://dbpedia.org/resource/Clare_Higgins" }},
					{ "actor" => { "value" => "http://dbpedia.org/resource/Andrew_Robinson" }}
        ]
      }
    }

		allow(HTTParty).to receive(:get).and_return(double(success?: true, body: response.to_json))
		result = DbpediaRequest.find_actors_by_film("Hellraiser")
		expect(result).to eq(["Ashley_Laurence","Clare_Higgins","Andrew_Robinson"])
	end
end