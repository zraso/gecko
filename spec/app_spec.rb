require 'rspec'
require 'rack/test'
require_relative '../app'

ENV['RACK_ENV'] = 'test'

RSpec.describe 'Film Service' do
	include Rack::Test::Methods

	def app
		FilmService
	end

  let(:actor) { "Tom_Hanks" }
  let(:films) { ["Forrest Gump", "Cast Away"] }
  let(:expected_response) { { "films" => films } }

  before(:each) do
    # Clear cache before each test
    CacheSingleton.instance.store(actor, nil)
  end

  let(:cache_file) { 'test_cache.store' }

	context "films for an actor" do
		it "returns a list of films for an actor" do
	
			allow(CacheSingleton.instance).to receive(:fetch).with(actor).and_return(nil)
			allow(CacheSingleton.instance).to receive(:store).with(actor, anything)
			allow(DbpediaRequest).to receive(:find_films_by_actor).with(actor).and_return(films)
	
			get '/', actor: actor
			expect(last_response).to be_ok
			expect(JSON.parse(last_response.body)).to eq(expected_response)
		end

    it "caches the film list" do
			allow(DbpediaRequest).to receive(:find_films_by_actor).with(actor).and_return(films)
  
      # Ensure cache is empty initially
      expect(CacheSingleton.instance.fetch(actor)).to be_nil
  
      # First request to store in cache
      get '/', actor: actor
			expect(last_response).to be_ok
			expect(JSON.parse(last_response.body)).to eq(expected_response)
  
      # Ensure data is stored in cache
      expect(CacheSingleton.instance.fetch(actor)).to eq(films)
  
      # Mocking cache fetch to return the film list
      allow(CacheSingleton.instance).to receive(:fetch).with(actor).and_return(films)
  
      # Second request to fetch from cache
      get '/', actor: actor
			expect(last_response).to be_ok
			expect(JSON.parse(last_response.body)).to eq(expected_response)
    end
	end

	context "actors in a film" do
		it "returns a list of actors in a film" do
			film = "Hellraiser"
	
			allow_any_instance_of(Cache).to receive(:fetch).with(film).and_return(nil)
			allow_any_instance_of(Cache).to receive(:store).with(film, anything)
			allow(DbpediaRequest).to receive(:find_actors_by_film).with(film).and_return(["Ashley Laurence","Clare Higgins","Andrew Robinson"])

			get '/', film: film
			expect(last_response).to be_ok
			expect(JSON.parse(last_response.body)).to eq({"actors" => ["Ashley Laurence","Clare Higgins","Andrew Robinson"]})
		end
	end

	it "returns a 400 error for invalid parameters" do
    get '/'
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({"error" => "Invalid parameters"})
  end
end