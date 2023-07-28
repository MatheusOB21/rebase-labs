require 'sidekiq'
class Worker
  include Sidekiq::Worker
  def perform(csv)
    require_relative 'import_from_csv'
    ImportCSV.insert_data(csv)
  end
end