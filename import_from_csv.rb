require 'pg'
require 'csv'

$postgresdb = PG.connect(host: HOST, user: USER, password: PASSWORD)                                        

def patient_insert(patient)
  $postgresdb.exec('INSERT INTO patients(cpf, name, email, birth_date, address, city, state) 
  VALUES ($1, $2, $3, $4, $5, $6, $7)', 
  [patient['cpf'], patient['nome paciente'], patient['email paciente'], patient['data nascimento paciente'], 
   patient['endereço/rua paciente'], patient['cidade paciente'], patient['estado patiente']])
end

def doctor_insert(doctor)
  $postgresdb.exec('INSERT INTO doctors(crm, state_crm, name, email) 
  VALUES ($1, $2, $3, $4)', 
  [doctor['crm médico'], doctor['crm médico estado'] , doctor['nome médico'], doctor['email médico']])
end

def exam_insert(exam, patient, doctor)
  $postgresdb.exec('INSERT INTO exams(result_token, date, patient_id, doctor_id) 
  VALUES ($1, $2, $3, $4)', 
  [exam['token resultado exame'], exam['data exame'], patient[0]['id'], doctor[0]['id']])
end

def type_insert(type)
  $postgresdb.exec('INSERT INTO types(result_token_exam, type, limits_type, result_type) 
  VALUES ($1, $2, $3, $4)', 
  [type['token resultado exame'], type['tipo exame'], type['limites tipo exame'], type['resultado tipo exame']])
end

def patient_find(cpf)
  $postgresdb.exec('SELECT * FROM patients WHERE cpf = $1', [cpf]).to_a
end

def doctor_find(crm)
  $postgresdb.exec('SELECT * FROM doctors WHERE crm = $1', [crm]).to_a
end

def exam_find(token)
  $postgresdb.exec('SELECT * FROM exams WHERE result_token = $1', [token]).to_a
end

def format_csv(csv)

  if csv.class == String
    rows = CSV.parse(csv, col_sep: ';')
  else
    rows = CSV.read("./data.csv", col_sep: ';')
  end 

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
  
  rows.each do |row|
    patient = patient_find(row['cpf'])
    doctor = doctor_find(row['crm médico'])
    exam = exam_find(row['token resultado exame'])
       
    if patient.empty?   
      patient_insert(row)
      patient = patient_find(row['cpf'])
    end

    if doctor.empty?
      doctor_insert(row)
      doctor = doctor_find(row['crm médico'])
    end  
    
    exam_insert(row, patient, doctor) if exam.empty? 
    type_insert(row) 
  end
end

