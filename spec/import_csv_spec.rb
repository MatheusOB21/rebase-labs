require_relative '../app/import_from_csv.rb'
require_relative 'spec_helper'
require 'csv'

describe 'formatação do CSV' do
  it 'deve retornar uma array' do
    csv = File.open("support/data.csv")

    result = ImportCSV.format_csv(csv)

    expect(result.class).to eq Array
  end
  it 'deve retornar uma com as chaves do CSV' do
    csv = File.open("support/data.csv")

    result = ImportCSV.format_csv(csv)

    expect(result.first.keys).to include('cpf')
    expect(result.first.keys).to include('nome paciente')
    expect(result.first.keys).to include('data nascimento paciente')
    expect(result.first.keys).to include('endereço/rua paciente')
    expect(result.first.keys).to include('cidade paciente')
    expect(result.first.keys).to include('estado patiente')
    expect(result.first.keys).to include('crm médico')
    expect(result.first.keys).to include('crm médico estado')
    expect(result.first.keys).to include('nome médico')
    expect(result.first.keys).to include('email médico')
    expect(result.first.keys).to include('token resultado exame')
    expect(result.first.keys).to include('data exame')
    expect(result.first.keys).to include('tipo exame')
    expect(result.first.keys).to include('limites tipo exame')
    expect(result.first.keys).to include('resultado tipo exame')
  end
end