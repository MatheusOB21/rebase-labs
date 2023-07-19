require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'csv'

get '/tests' do
  $postgresdb = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin')

  result =  $postgresdb.exec('SELECT patients.*, exams.crm_doctor, state_crm_doctor, name_doctor, 
                              email_doctor, token, data_exam, type_exam, limit_type_exam, 
                              result_type_exam FROM patients INNER JOIN exams ON exams.patient_id = patients.id')
  
  result.to_a.to_json
  
  # rows = CSV.read("./data.csv", col_sep: ';')

  # columns = rows.shift

  # rows.map do |row|
  #   row.each_with_object({}).with_index do |(cell, acc), idx|
  #     column = columns[idx]
  #     acc[column] = cell
  #   end
  # end.to_json
end

get '/tests_json' do
  
end

get 'instructions' do
end

get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)