require_relative 'spec_helper'
require_relative '../server'
require_relative '../app/import_from_csv'
require 'sinatra'

RSpec.describe 'Web' do
  def app
    Sinatra::Application
  end

  it "/index retorna HTML com todos exames cadastrados", js: true do
    csv = File.open("spec/support/data_example.csv")
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    ImportCSV.insert_data(csv, pg)
    pg.close
    
    get '/index'

    sleep 3
    expect(last_response.status).to eq 200
    expect(last_response.body).to include('ADFZ17')
  end

end