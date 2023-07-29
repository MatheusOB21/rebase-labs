require_relative 'spec_helper'
require_relative '../server'
require 'sinatra'

RSpec.describe 'API' do
  after(:each) do
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    DB.delete_data(pg)
  end
  after(:all) do
    pg = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin123')
    pg.exec('DROP DATABASE test')
    pg.close
  end

  def app
    Sinatra::Application
  end

  it "/tests retorna 404 e not found, caso não tenha exame cadastrado" do
    get '/tests'
    
    expect(last_response.status).to eq 404
    expect(last_response.body).to include('Not found')
  end  
  
  it "/tests retorna 202 e todos os exames cadastrados" do
    body = File.open("support/data_example.csv")
    post '/import', params: "#{body.read}"
    
    get '/tests'

    expect(last_response.status).to eq 202
    expect(last_response.body).to include('Test')
  end  
end