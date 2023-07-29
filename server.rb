require 'sinatra'
require 'rack/handler/puma'
require 'json'
require_relative 'app/import_from_csv'
require_relative 'app/test'
require_relative 'app/worker'

#Web
get '/index' do
  content_type :html
  File.open('views/index.html')
end

get '/index/details' do
  content_type :html
  File.open('views/details.html')
end

# API
get '/tests' do
  content_type :json
  response = Test.all
  if response.any?
    status 200
    response.to_json
  else
    status 404
    {detail: "Not found"}.to_json
  end
end

get '/tests/format=json' do
  content_type :json
  response = Test.all_json
  if response.any?
    status 200
    response.to_json
  else
    status 404
    {detail: "Not found"}.to_json
  end
end

get '/tests/:token' do
  content_type :json
  response = Test.find(params['token'])
  if response.any?
    status 200
    response.first.to_json
  else
    status 404
    {detail: "Not found"}.to_json
  end
end

post '/import' do
  begin
    csv = request.body.read
    puts csv
    Worker.perform_async(csv)
    status 201
  rescue => exception
    status 404
    {detail: "Not created, error internal: #{exception}"}.to_json
    puts "NOTICE:  ERROR IMPORT"
  end
end

if ENV['APP_ENV'] != 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end