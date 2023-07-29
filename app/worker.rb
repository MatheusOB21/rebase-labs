require 'sidekiq'
require_relative 'import_from_csv'
class Worker
  include Sidekiq::Worker
  def perform(csv)
    host = 'postgresdb'
    user = 'admin'
    password = 'admin123'  
    dbname = ''   
  
    if ENV['APP_ENV'] == 'test'
      dbname = 'test'
    end

    postgresdb = PG.connect(host: host, dbname: dbname, user: user, password: password)
    ImportCSV.create_tables(postgresdb)
    ImportCSV.insert_data(csv, postgresdb)
    postgresdb.close
  end
end