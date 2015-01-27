require 'marsys'
require 'sinatra/base'
require 'json'
require 'slim'

load "agent.rb"
load "environment.rb"
load "core.rb"

class App < Sinatra::Base
  use Rack::Session::Pool
  set :public_folder, File.dirname(__FILE__) + '/../static'

  get '/' do
    slim :index
  end

  get '/init/:size/:stalker_population/:block_population/:strategy/:von_neumann' do
    options = {
      dimensions:                 params[:size].to_i,
      stalker_population:         params[:stalker_population].to_i,
      block_population:           params[:block_population].to_i,
      strategy:                   params[:strategy].to_i,
      von_neumann:                params[:von_neumann] == 'true'
    }
    session[:instance] = Core.new options
    content_type :json
    session[:instance].to_json
  end

  get '/turn' do
    sleep(1) if session[:instance].nil?
    begin
      session[:instance].environment.turn
    rescue => error
      puts error.inspect
    end

    content_type :json
    session[:instance].to_json
  end

  run! if app_file == $0 # run Sinatra
end
