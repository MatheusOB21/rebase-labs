require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'json'
require_relative 'test'

get '/index' do
  File.open('index.html')
end

get '/tests' do
  content_type :json
  response = Test.all.to_json
end

get '/tests/format=json' do
  content_type :json
  response = Test.all_json.to_json
end

get '/tests/:token' do
  content_type :json
  response = Test.find(params['token'])
  response.first.to_json
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