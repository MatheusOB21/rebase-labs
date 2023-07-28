ENV['APP_ENV'] = 'test'

require_relative '../server'
require_relative 'spec_helper'
require 'sinatra'
require 'rspec'
require 'rack/test'

RSpec.describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "retorna todos os testes" do
    get '/tests'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end
end