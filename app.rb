require 'marsys'
require 'sinatra/base'
require 'json'
require 'slim'

load "agent.rb"
load "core.rb"

class App < Sinatra::Base
  use Rack::Session::Pool
  set :public_folder, File.dirname(__FILE__) + '/../static'

  get '/' do
    slim :index
  end

  get '/init/:size/:stalker_population/:block_population/:strategy' do
    options = {
      dimensions:                 params[:size].to_i,
      stalker_population:         params[:stalker_population].to_i,
      block_population:           params[:block_population].to_i,
      strategy:                   params[:strategy].to_i
    }
    session[:instance] = Core.new options
    content_type :json
    session[:instance].environment.to_json
  end

  get '/turn' do
    begin
      session[:instance].environment.turn
    rescue => error
      puts error.inspect
    end

    content_type :json
    session[:instance].environment.to_json
  end

  run! if app_file == $0 # run Sinatra
end