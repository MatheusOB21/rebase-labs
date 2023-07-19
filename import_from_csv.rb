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

$postgresdb.exec("CREATE TABLE IF NOT EXISTS exams (patient_id SERIAL REFERENCES patients(id),
                                             crm_doctor VARCHAR, 
                                             state_crm_doctor VARCHAR(2), 
                                             name_doctor VARCHAR, 
                                             email_doctor VARCHAR, 
                                             token VARCHAR, 
                                             data_exam VARCHAR, 
                                             type_exam VARCHAR, 
                                             limit_type_exam VARCHAR, 
                                             result_type_exam VARCHAR)")

def patient_insert(patient)
  $postgresdb.exec('INSERT INTO patients(cpf, name, email, birth_data, address, city, state) 
  VALUES ($1, $2, $3, $4, $5, $6, $7)', 
  [patient['cpf'], patient['nome paciente'], patient['email paciente'], patient['data nascimento paciente'], 
   patient['endereço/rua paciente'], patient['cidade paciente'], patient['estado patiente']])
end

def exam_insert(exam, patient)
  $postgresdb.exec('INSERT INTO exams(crm_doctor, state_crm_doctor, name_doctor, email_doctor, token, data_exam, type_exam, limit_type_exam, result_type_exam, patient_id) 
  VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)', 
  [exam['crm médico'], exam['crm médico estado'] , exam['nome médico'], exam['email médico'], exam['token resultado exame'], exam['data exame'], 
   exam['tipo exame'], exam['limites tipo exame'], exam['resultado tipo exame'], patient[0]['id']])
end

def patient_find(cpf)
  $postgresdb.exec("SELECT * FROM patients WHERE cpf='#{cpf}'").to_a
end

def doctor_find(cpf)
  $postgresdb.exec("SELECT * FROM patients WHERE cpf='#{cpf}'").to_a
end


rows.each do |row|
  patient = patient_find(row['cpf'])

  if patient.empty?   
    patient_insert(row)
    patient = patient_find(row['cpf'])
  end
  
  exam_insert(row, patient)
end

# PACIENTE
# "cpf":"048.973.170-88",
# "nome paciente":"Emilly Batista Neto",
# "email paciente":"gerald.crona@ebert-quigley.com",
# "data nascimento paciente":"2001-03-11",
# "endereço/rua paciente":"165 Rua Rafaela",
# "cidade paciente":"Ituverava","
# estado patiente":"Alagoas",

# EXAME
# id paciente
# "crm médico":"B000BJ20J4",
# "crm médico estado":"PI",
# "nome médico":"Maria Luiza Pires",
# "email médico":"denna@wisozk.biz",
# "token resultado exame":"IQCZ17",
# "data exame":"2021-08-05",
# "tipo exame":"hemácias",
# "limites tipo exame":"45-52",
# "resultado tipo exame":"97"}


# PACIENTE
#"cpf":"048.973.170-88",
#"nome paciente":"Emilly Batista Neto",
#"email paciente":"gerald.crona@ebert-quigley.com",
#"data nascimento paciente":"2001-03-11",
#"endereço/rua paciente":"165 Rua Rafaela",
#"cidade paciente":"Ituverava",
#"estado patiente":"Alagoas",

# EXAME
# id paciente
#"crm médico":"B000BJ20J4",
#"crm médico estado":"PI",
#"nome médico":"Maria Luiza Pires",
#"email médico":"denna@wisozk.biz",
#"token resultado exame":"IQCZ17",
#"data exame":"2021-08-05",
#"tipo exame":"leucócitos",
#"limites tipo exame":"9-61",
#"resultado tipo exame":"89"}