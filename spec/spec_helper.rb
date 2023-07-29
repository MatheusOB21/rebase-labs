ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require_relative '../app/db'

RSpec.configure do |conf|
  
  conf.before(:all){
    begin
      db = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin123')
      db.exec('CREATE DATABASE test')
      db.close
    rescue => exception
      puts "NOTICE:  Database teste já existe"
    end
  }
  
  conf.before(:each) {     
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    DB.create_tables(pg)
    pg.close
  }

  conf.after(:each) {
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    DB.delete_data(pg) 
    pg.close
  }

  conf.after(:all) {    
    pg = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin123')
    pg.exec('DROP DATABASE test')
    pg.close
  }


  conf.include Rack::Test::Methods

  conf.before(type: :system) do
    driven_by(:rack_test)
  end
end