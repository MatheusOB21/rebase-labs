require 'sidekiq'
require_relative 'import_from_csv'
class Worker
  include Sidekiq::Worker
  @@HOST = 'postgresdb'
  @@USER = 'admin'
  @@PASSWORD = 'admin123'  
  @@DBNAME = ''   

  if ENV['APP_ENV'] == 'test'
    @@DBNAME = 'test'
  end
  def perform(csv)
    postgresdb = PG.connect(host: @@HOST, dbname: @@DBNAME, user: @@USER, password: @@PASSWORD)
    ImportCSV.insert_data(csv, postgresdb)
    postgresdb.close
  end
end