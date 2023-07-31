CREATE TABLE IF NOT EXISTS patients(id SERIAL, 
                                    cpf VARCHAR PRIMARY KEY UNIQUE, 
                                    name VARCHAR, 
                                    email VARCHAR, 
                                    birth_date VARCHAR, 
                                    address VARCHAR, 
                                    city VARCHAR, 
                                    state VARCHAR);

CREATE TABLE IF NOT EXISTS doctors(id SERIAL, 
                                   crm VARCHAR PRIMARY KEY UNIQUE, 
                                   state_crm VARCHAR(2), 
                                   name VARCHAR, 
                                   email VARCHAR); 

CREATE TABLE IF NOT EXISTS exams (id SERIAL,
                                  result_token VARCHAR PRIMARY KEY, 
                                  patient_cpf VARCHAR REFERENCES patients(cpf),
                                  doctor_crm VARCHAR REFERENCES doctors(crm),
                                  date VARCHAR);   

CREATE TABLE IF NOT EXISTS types (id SERIAL,
                                  result_token_exam VARCHAR REFERENCES exams(result_token), 
                                  type VARCHAR, 
                                  limits_type VARCHAR, 
                                  result_type VARCHAR,
                                  UNIQUE (result_token_exam, type));                                                                                                   
