require 'pg'
require 'csv'


rows = CSV.read("./data.csv", col_sep: ';')
rows.shift

$postgresdb = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin')

$postgresdb.exec("CREATE TABLE patients (id SERIAL PRIMARY KEY, 
                                        cpf VARCHAR, 
                                        name VARCHAR, 
                                        email VARCHAR, 
                                        birth_data VARCHAR, 
                                        address VARCHAR, 
                                        city VARCHAR, 
                                        state VARCHAR)")

$postgresdb.exec("CREATE TABLE exams (crm_doctor VARCHAR, 
                                     state_crm_doctor VARCHAR(2), 
                                     name_doctor VARCHAR, 
                                     email_doctor VARCHAR, 
                                     token VARCHAR, 
                                     data_exam VARCHAR, 
                                     type_exam VARCHAR, 
                                     limit_type_exam VARCHAR, 
                                     result_type_exam VARCHAR, 
                                     patient_id SERIAL REFERENCES patients(id))")

patients = rows.map{ |row| row.first(6) }
exams = rows.map{|row| row.last(9)}

def patient_insert(patient)
  $postgresdb.exec("INSERT INTO patients(cpf, name, email, birth_data, address, city, state) 
  VALUES ('#{patient[0]}', '#{patient[1]}', '#{patient[2]}', '#{patient[3]}', '#{patient[4]}', '#{patient[5]}', '#{patient[6]}')")
end

def exam_insert(exam, patient_id)
  $postgresdb.exec("INSERT INTO exams(crm_doctor, state_crm_doctor, name_doctor, email_doctor, token, data_exam, type_exam, limit_type_exam, result_type_exam, patient_id) 
  VALUES ('#{exam[7]}', '#{exam[8]}' , '#{exam[9]}', '#{exam[10]}', '#{exam[11]}', '#{exam[12]}', '#{exam[13]}', '#{exam[14]}', '#{exam[15]}','#{patient_id.id}')")
end

rows.each do |row|
  $postgresdb
    patient_insert(row)
    patient_id = $postgresdb.exec("SELECT id FROM patients WHERE cpf='#{row[0]}'").to_a
    exam_insert(row, patient_id)
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