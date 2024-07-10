require 'rspec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

RSpec.describe 'Film Service' do
	include Rack::Test::Methods

	def app
		FilmService
	end

  let(:actor) { "Macauley_Culkin" }
  let(:films) { ["Home Alone", "Richie Rich"] }
  let(:expected_response) { { "films" => films } }

  let(:film) { "Hellraiser" }
  let(:actors) { ["Ashley Laurence", "Clare Higgins", "Andrew Robinson"] }
  let(:expected_response_actors) { { "actors" => actors } }

  before(:each) do
    CacheSingleton.instance.store(actor, nil)
    CacheSingleton.instance.store(film, nil)
  end

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
  
      # Cache is empty
      expect(CacheSingleton.instance.fetch(actor)).to be_nil
  
      # Store in cache
      get '/', actor: actor
			expect(last_response).to be_ok
			expect(JSON.parse(last_response.body)).to eq(expected_response)
  
      # Data is stored
      expect(CacheSingleton.instance.fetch(actor)).to eq(films)
  
      # Check cache
      allow(CacheSingleton.instance).to receive(:fetch).with(actor).and_return(films)
  
      # Fetch from cache
      get '/', actor: actor
			expect(last_response).to be_ok
			expect(JSON.parse(last_response.body)).to eq(expected_response)
    end

    it "returns JSON format" do
      allow(CacheSingleton.instance).to receive(:fetch).with(actor).and_return(nil)
      allow(CacheSingleton.instance).to receive(:store).with(actor, anything)
      allow(DbpediaRequest).to receive(:find_films_by_actor).with(actor).and_return(films)

      get '/', actor: actor
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/json')
      expect { JSON.parse(last_response.body) }.not_to raise_error
    end
	end

	context "actors in a film" do
		it "returns a list of actors in a film" do
			allow(CacheSingleton.instance).to receive(:fetch).with(film).and_return(nil)
			allow(CacheSingleton.instance).to receive(:store).with(film, anything)
			allow(DbpediaRequest).to receive(:find_actors_by_film).with(film).and_return(actors)

			get '/', film: film
			expect(last_response).to be_ok
			expect(JSON.parse(last_response.body)).to eq(expected_response_actors)
		end

    it "caches the actors list" do
      allow(DbpediaRequest).to receive(:find_actors_by_film).with(film).and_return(actors)

      # Cache is empty
      expect(CacheSingleton.instance.fetch(film)).to be_nil

      # Store in cache
      get '/', film: film
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(expected_response_actors)

      # Data is stored
      expect(CacheSingleton.instance.fetch(film)).to eq(actors)

      # Check cache
      expect(CacheSingleton.instance.fetch(film)).to eq(actors)

      # Fetch from catch
      get '/', film: film
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(expected_response_actors)
    end

    it "returns JSON format" do
      allow(CacheSingleton.instance).to receive(:fetch).with(film).and_return(nil)
      allow(CacheSingleton.instance).to receive(:store).with(film, anything)
      allow(DbpediaRequest).to receive(:find_actors_by_film).with(film).and_return(actors)

      get '/', film: film
      expect(last_response).to be_ok
      expect(last_response.headers['Content-Type']).to eq('application/json')
      expect { JSON.parse(last_response.body) }.not_to raise_error
    end
	end

	it "returns a 400 error for invalid parameters" do
    get '/'
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({"error" => "Invalid parameters"})
  end
end