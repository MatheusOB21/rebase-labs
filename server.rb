require 'sinatra'
require 'rack/handler/puma'
require 'json'
require_relative 'app/import_from_csv'
require_relative 'app/test'
require_relative 'app/worker'
require_relative 'app/db'

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
    if response.length > 1
      response.to_json
    else
      response.first.to_json
    end
  else
    status 404
    {detail: "Not found"}.to_json
  end
end

post '/import' do
  begin
    csv = request.body.read
    Worker.perform_async(csv)
    status 201
  rescue => exception
    status 404
    {detail: "Not created, error internal: #{exception}"}.to_json
    puts "NOTICE:  ERROR IMPORT"
  end
  redirect '/index'
end

# Configuration
options "*" do
  response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end

configure do
  set :protection, :except => [:json_csrf]
end

before(:all) do
  response.headers['Access-Control-Allow-Origin'] = 'http://0.0.0.0'
end

if ENV['APP_ENV'] != 'test'
  postgresdb = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin123')
  DB.create_tables(postgresdb)
  postgresdb.close

  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end