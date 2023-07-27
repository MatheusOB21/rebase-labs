require 'pg'

HOST = 'postgresdb'
USER = 'admin'
PASSWORD = 'admin123'
$postgresdb = PG.connect(host: HOST, user: USER, password: PASSWORD)

$postgresdb.exec("CREATE TABLE IF NOT EXISTS patients (id SERIAL PRIMARY KEY, 
    cpf VARCHAR UNIQUE, 
    name VARCHAR, 
    email VARCHAR, 
    birth_date VARCHAR, 
    address VARCHAR, 
    city VARCHAR, 
    state VARCHAR)")

$postgresdb.exec("CREATE TABLE IF NOT EXISTS doctors (id SERIAL PRIMARY KEY, 
    crm VARCHAR UNIQUE, 
    state_crm VARCHAR(2), 
    name VARCHAR, 
    email VARCHAR)")

$postgresdb.exec("CREATE TABLE IF NOT EXISTS exams (id SERIAL,
    result_token VARCHAR PRIMARY KEY, 
    patient_cpf VARCHAR REFERENCES patients(cpf),
    doctor_crm VARCHAR REFERENCES doctors(crm),
    date VARCHAR)")

$postgresdb.exec("CREATE TABLE IF NOT EXISTS types (id SERIAL,
    result_token_exam VARCHAR REFERENCES exams(result_token), 
    type VARCHAR, 
    limits_type VARCHAR, 
    result_type VARCHAR,
    UNIQUE (result_token_exam, type))")