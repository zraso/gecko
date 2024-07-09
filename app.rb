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
        actor = params[:actor]
        result = DbpediaRequest.find_films_by_actor(actor)
        { films: result }.to_json
    elsif params[:film]
        film = params[:film]
        result = DbpediaRequest.find_actors_by_film(film)
        { actors: result }.to_json
    else
        halt 400, { error: 'Invalid parameters' }.to_json
    end
  end

  run! if app_file == $0
end