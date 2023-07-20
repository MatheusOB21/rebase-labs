require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'
require 'json'
require_relative 'test'

get '/tests' do
  response = Test.all.to_json
end

get '/tests_json' do
  
end

get 'instructions' do
end

get '/hello' do
  'Hello World'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)