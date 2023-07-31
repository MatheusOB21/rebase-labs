require_relative 'spec_helper'
require_relative '../app/import_from_csv.rb'
require_relative '../app/test.rb'
require 'csv'

describe 'Test' do  
  it '.all retorna todos os exames cadastrados' do
    csv = File.open("spec/support/data_example.csv")
    pg = PG.connect(host: 'postgresdb', dbname: 'test', user: 'admin', password: 'admin123')
    ImportCSV.insert_data(csv, pg)
    pg.close
    
    result = Test.all

    expect(result.class).to eq Array
    expect(result.first.keys).to include('cpf')
    expect(result.first.keys).to include('patient_name')
    expect(result.first.keys).to include('patient_email')
    expect(result.first.keys).to include('patient_birth_date')
    expect(result.first.keys).to include('patient_address')
    expect(result.first.keys).to include('patient_city')
    expect(result.first.keys).to include('patient_state')
    expect(result.first.keys).to include('doctor_crm')
    expect(result.first.keys).to include('doctor_crm_state')
    expect(result.first.keys).to include('doctor_email')
    expect(result.first.keys).to include('exam_result_token')
    expect(result.first.keys).to include('exam_date')
    expect(result.first.keys).to include('exam_type')
    expect(result.first.keys).to include('limits_exam_type')
    expect(result.first.keys).to include('result_exam_type')
  end  
end