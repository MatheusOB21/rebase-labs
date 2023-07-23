require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'json'
require_relative 'db'
require_relative 'test'

get '/index' do
  content_type :html
  File.open('views/index.html')
end

get '/index/details' do
  content_type :html
  File.open('views/details.html')
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

post '/import' do
  csv = params['csv']
  begin
    Test.import_tests(csv)
    "OK"  
  rescue StandardError => e
    puts "Rescued: #{e.inspect}"    
  end
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)