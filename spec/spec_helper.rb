ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../app/db'

begin
  db = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin123')
  db.exec('CREATE DATABASE test')
  db.close
rescue => exception
  puts "NOTICE:  Database teste já existe"
end
 
DB.create_tables(PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123'))

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

  conf.before(type: :system) do
    driven_by(:rack_test)
  end
end