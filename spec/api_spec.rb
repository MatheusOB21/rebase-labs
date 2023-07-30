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

  it "/tests retorna 200 e todos os exames cadastrados" do
    csv = File.open("spec/support/data_example.csv")
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
  
  it "/tests/format=json e retorna 200 e todos os exames cadastrados, com formato JSON" do
    csv = File.open("spec/support/data_example.csv")
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    ImportCSV.insert_data(csv, pg)
    pg.close
    
    get '/tests/format=json'

    expect(last_response.status).to eq 200
    expect(last_response.body).to include('ADFZ17')
    expect(last_response.body).to include('OX1I67')
    expect(JSON.parse(last_response.body).class).to eq Array
    expect(JSON.parse(last_response.body).first.keys).to include('result_token')
    expect(JSON.parse(last_response.body).first.keys).to include('result_date')
    expect(JSON.parse(last_response.body).first.keys).to include('patient')
    expect(JSON.parse(last_response.body).first.keys).to include('doctor')
    expect(JSON.parse(last_response.body).first.keys).to include('tests')
    expect(JSON.parse(last_response.body).first['tests'].class).to eq Array
    expect(JSON.parse(last_response.body).first['tests'].class).to eq Array
  end
  
  it "/tests/:token retorna hash com detalhes do exame, caso encontre apenas um" do
    csv = File.open("spec/support/data_example.csv")
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    ImportCSV.insert_data(csv, pg)
    pg.close
    
    get '/tests/ADFZ17'

    expect(last_response.status).to eq 200
    expect(last_response.body).to include('ADFZ17')
    expect(last_response.body).not_to include('OX1I67')
    expect(JSON.parse(last_response.body).class).to eq Hash
    expect(JSON.parse(last_response.body).keys).to include('result_token')
    expect(JSON.parse(last_response.body).keys).to include('result_date')
    expect(JSON.parse(last_response.body).keys).to include('patient')
    expect(JSON.parse(last_response.body).keys).to include('doctor')
    expect(JSON.parse(last_response.body).keys).to include('tests')
    expect(JSON.parse(last_response.body)['tests'].class).to eq Array
    expect(JSON.parse(last_response.body)['tests'].class).to eq Array
  end
  
  it "/tests/:token retorna array com detalhes de exames, caso encontre mais de um" do
    csv = File.open("spec/support/data.csv")
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    ImportCSV.insert_data(csv, pg)
    pg.close
    
    get '/tests/AD'

    expect(last_response.status).to eq 200
    expect(last_response.body).to include('YPV4AD')
    expect(last_response.body).to include('AD0XNN')
    expect(JSON.parse(last_response.body).class).to eq Array
  end

end