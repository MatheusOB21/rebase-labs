ENV['APP_ENV'] = 'test'

require_relative '../server'
require_relative 'spec_helper'
require 'sinatra'
require 'rspec'
require 'rack/test'

describe 'The HelloWorld App' do
  after(:each) do
    DB.drop_tables(PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123'))
  end
  after(:all) do
    PG.connect(host: 'postgresdb', user: 'admin', password: 'admin123').exec('DROP DATABASE test')
  end

  def app
    Sinatra::Application
  end

  it "retorna todos os testes" do
    get '/tests'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end  

end