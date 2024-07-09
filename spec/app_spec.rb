require 'rspec'
require 'rack/test'
require_relative '../app'

ENV['RACK_ENV'] = 'test'

RSpec.describe 'Film Service' do
	include Rack::Test::Methods

	def app
		FilmService
	end

	it "returns a list of films for an actor" do
		allow(DbpediaRequest).to receive(:find_films_by_actor).with("Tom_Hanks").and_return(["Forrest Gump", "Cast Away"])
		get '/', actor: 'Tom_Hanks'
		expect(last_response).to be_ok
		expect(JSON.parse(last_response.body)).to eq({"films" => ["Forrest Gump", "Cast Away"]})
	end

	it "returns a list of actors in a film" do
		allow(DbpediaRequest).to receive(:find_actors_by_film).with("Hellraiser").and_return(["Ashley Laurence","Clare Higgins","Andrew Robinson"])
		get '/', film: 'Hellraiser'
		expect(last_response).to be_ok
		expect(JSON.parse(last_response.body)).to eq({"actors" => ["Ashley Laurence","Clare Higgins","Andrew Robinson"]})
	end

	it "returns a 400 error for invalid parameters" do
    get '/'
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({"error" => "Invalid parameters"})
  end
end