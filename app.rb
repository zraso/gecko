require 'json'
require 'sinatra'
require_relative 'dbpedia_request'

class FilmService < Sinatra::Base
  set :port, 9292

  before do
    content_type :json
  end

  get '/' do
    if params[:actor]
      actor = params['actor']
      films = CacheSingleton.instance.fetch(actor) || DbpediaRequest.find_films_by_actor(actor)
      CacheSingleton.instance.store(actor, films) if CacheSingleton.instance.fetch(actor).nil?
      { films: films }.to_json
    elsif params[:film]
      film = params['film']
      actors = CacheSingleton.instance.fetch(film) || DbpediaRequest.find_actors_by_film(film)
      CacheSingleton.instance.store(film, actors) if CacheSingleton.instance.fetch(film).nil?
      { actors: actors }.to_json
    else
        halt 400, { error: 'Invalid parameters' }.to_json
    end
  end

  run! if app_file == $0
end