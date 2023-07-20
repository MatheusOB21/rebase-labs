require 'pg'
require 'csv'

rows = CSV.read("./data.csv", col_sep: ';')
columns = rows.shift

rows.map! do |row|
  row.each_with_object({}).with_index do |(cell, acc), idx|
    column = columns[idx]
    acc[column] = cell
  end
end

$postgresdb = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin')

$postgresdb.exec("CREATE TABLE IF NOT EXISTS patients (id SERIAL PRIMARY KEY, 
                                             cpf VARCHAR, 
                                             name VARCHAR, 
                                             email VARCHAR, 
                                             birth_data VARCHAR, 
                                             address VARCHAR, 
                                             city VARCHAR, 
                                             state VARCHAR)")

$postgresdb.exec("CREATE TABLE IF NOT EXISTS doctors (id SERIAL PRIMARY KEY, 
                                             crm VARCHAR, 
                                             state_crm VARCHAR(2), 
                                             name VARCHAR, 
                                             email VARCHAR)")

$postgresdb.exec("CREATE TABLE IF NOT EXISTS exams (id SERIAL,
                                             patient_id SERIAL REFERENCES patients(id),
                                             doctor_id SERIAL REFERENCES doctors(id),
                                             result_token VARCHAR, 
                                             date VARCHAR, 
                                             type VARCHAR, 
                                             limits_type VARCHAR, 
                                             result_type VARCHAR)")

def patient_insert(patient)
  $postgresdb.exec('INSERT INTO patients(cpf, name, email, birth_data, address, city, state) 
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
  $postgresdb.exec('INSERT INTO exams(result_token, date, type, limits_type, result_type, patient_id, doctor_id) 
  VALUES ($1, $2, $3, $4, $5, $6, $7)', 
  [exam['token resultado exame'], exam['data exame'], exam['tipo exame'], exam['limites tipo exame'], exam['resultado tipo exame'], 
   patient[0]['id'], doctor[0]['id']])
end

def patient_find(cpf)
  $postgresdb.exec("SELECT * FROM patients WHERE cpf='#{cpf}'").to_a
end

def doctor_find(crm)
  $postgresdb.exec("SELECT * FROM doctors WHERE crm='#{crm}'").to_a
end


rows.each do |row|
  patient = patient_find(row['cpf'])
  doctor = doctor_find(row['crm médico'])

  if patient.empty?   
    patient_insert(row)
    patient = patient_find(row['cpf'])
  end

  if doctor.empty?
    doctor_insert(row)
    doctor = doctor_find(row['crm médico'])
  end  
  
  exam_insert(row, patient, doctor)
end

# PACIENTE
# "cpf":"048.973.170-88",
# "nome paciente":"Emilly Batista Neto",
# "email paciente":"gerald.crona@ebert-quigley.com",
# "data nascimento paciente":"2001-03-11",
# "endereço/rua paciente":"165 Rua Rafaela",
# "cidade paciente":"Ituverava","
# "estado patiente":"Alagoas",

# MEDICO
# "crm médico":"B000BJ20J4",
# "crm médico estado":"PI",
# "nome médico":"Maria Luiza Pires",
# "email médico":"denna@wisozk.biz",

# EXAME
# "id paciente"
# "id medico"
# "token resultado exame":"IQCZ17",
# "data exame":"2021-08-05",
# "tipo exame":"hemácias",
# "limites tipo exame":"45-52",
# "resultado tipo exame":"97"}