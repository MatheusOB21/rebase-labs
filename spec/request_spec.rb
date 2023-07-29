require_relative 'spec_helper'
require_relative '../server'
require_relative '../app/import_from_csv'
require 'sinatra'

RSpec.describe 'API' do
  def app
    Sinatra::Application
  end

  it "/tests retorna 404 e not found, caso não tenha exame cadastrado" do
    get '/tests'
    
    expect(last_response.status).to eq 404
    expect(last_response.body).to include('Not found')
  end

  it "/tests retorna 202 e todos os exames cadastrados" do
    csv = File.open("support/data_example.csv")
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    ImportCSV.insert_data(csv, pg)
    pg.close
    
    get '/tests'

    expect(last_response.status).to eq 200
    expect(last_response.body).to include('ADFZ17')
    expect(last_response.body).to include('OX1I67')
    expect(JSON.parse(last_response.body).first.keys).to include('cpf')
    expect(JSON.parse(last_response.body).first.keys).to include('patient_name')
    expect(JSON.parse(last_response.body).first.keys).to include('patient_email')
    expect(JSON.parse(last_response.body).first.keys).to include('patient_birth_date')
    expect(JSON.parse(last_response.body).first.keys).to include('patient_address')
    expect(JSON.parse(last_response.body).first.keys).to include('patient_city')
    expect(JSON.parse(last_response.body).first.keys).to include('patient_state')
    expect(JSON.parse(last_response.body).first.keys).to include('doctor_crm')
    expect(JSON.parse(last_response.body).first.keys).to include('doctor_crm_state')
    expect(JSON.parse(last_response.body).first.keys).to include('doctor_email')
    expect(JSON.parse(last_response.body).first.keys).to include('exam_result_token')
    expect(JSON.parse(last_response.body).first.keys).to include('exam_date')
    expect(JSON.parse(last_response.body).first.keys).to include('exam_type')
    expect(JSON.parse(last_response.body).first.keys).to include('limits_exam_type')
    expect(JSON.parse(last_response.body).first.keys).to include('result_exam_type')
  end
  
  it "/tests/format=json retorna 202 e todos os exames cadastrados, com formato JSON" do
    csv = File.open("support/data_example.csv")
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    ImportCSV.insert_data(csv, pg)
    pg.close
    
    get '/tests/format=json'

    expect(last_response.status).to eq 200
    expect(last_response.body).to include('banana')
    expect(last_response.body).to include('OX1I67')
  end
end