require 'pg'
require 'csv'

HOST = 'postgresdb'
USER = 'admin'
PASSWORD = 'admin123'                                

def patient_insert(patient, db)
  db.exec('INSERT INTO patients(cpf, name, email, birth_date, address, city, state) 
  VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING', 
  [patient['cpf'], patient['nome paciente'], patient['email paciente'], patient['data nascimento paciente'], 
   patient['endereço/rua paciente'], patient['cidade paciente'], patient['estado patiente']])
end

def doctor_insert(doctor, db)
  db.exec('INSERT INTO doctors(crm, state_crm, name, email) 
  VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING', 
  [doctor['crm médico'], doctor['crm médico estado'] , doctor['nome médico'], doctor['email médico']])
end

def exam_insert(exam, db)
  db.exec('INSERT INTO exams(result_token, date, patient_cpf, doctor_crm) 
  VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING', 
  [exam['token resultado exame'], exam['data exame'], exam['cpf'], exam['crm médico']])
end

def type_insert(type, db)
  db.exec('INSERT INTO types(result_token_exam, type, limits_type, result_type) 
  VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING', 
  [type['token resultado exame'], type['tipo exame'], type['limites tipo exame'], type['resultado tipo exame']])
end

def format_csv(csv)
  rows = CSV.parse(csv, col_sep: ';', encoding: "UTF-8")

  columns = rows.shift

  rows.map! do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      
      acc[column] = cell
    end
  end

  rows
end

def insert_data(params)
  rows = format_csv(params)
  postgresdb = PG.connect(host: HOST, user: USER, password: PASSWORD)       

  rows.each do |row|
    patient_insert(row, postgresdb)
    doctor_insert(row, postgresdb)
    exam_insert(row, postgresdb)
    type_insert(row, postgresdb) 
  end
end

