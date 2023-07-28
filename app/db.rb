require 'pg'

class DB

	def self.create_tables(db)
		db.exec("CREATE TABLE IF NOT EXISTS patients(id SERIAL PRIMARY KEY, 
																													cpf VARCHAR UNIQUE, 
																													name VARCHAR, 
																													email VARCHAR, 
																													birth_date VARCHAR, 
																													address VARCHAR, 
																													city VARCHAR, 
																													state VARCHAR)")

		db.exec("CREATE TABLE IF NOT EXISTS doctors(id SERIAL PRIMARY KEY, 
																													crm VARCHAR UNIQUE, 
																													state_crm VARCHAR(2), 
																													name VARCHAR, 
																													email VARCHAR)")

		db.exec("CREATE TABLE IF NOT EXISTS exams (id SERIAL,
																												result_token VARCHAR PRIMARY KEY, 
																												patient_cpf VARCHAR REFERENCES patients(cpf),
																												doctor_crm VARCHAR REFERENCES doctors(crm),
																												date VARCHAR)")

		db.exec("CREATE TABLE IF NOT EXISTS types (id SERIAL,
																												result_token_exam VARCHAR REFERENCES exams(result_token), 
																												type VARCHAR, 
																												limits_type VARCHAR, 
																												result_type VARCHAR,
																												UNIQUE (result_token_exam, type))")
	end

	def self.patient_insert(patient, db)
		db.exec('INSERT INTO patients(cpf, name, email, birth_date, address, city, state) 
		VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING', 
		[patient['cpf'], patient['nome paciente'], patient['email paciente'], patient['data nascimento paciente'], 
		 patient['endereço/rua paciente'], patient['cidade paciente'], patient['estado patiente']])
	end

	def self.doctor_insert(doctor, db)
		db.exec('INSERT INTO doctors(crm, state_crm, name, email) 
		VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING', 
		[doctor['crm médico'], doctor['crm médico estado'] , doctor['nome médico'], doctor['email médico']])
	end

	def self.exam_insert(exam, db)
		db.exec('INSERT INTO exams(result_token, date, patient_cpf, doctor_crm) 
		VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING', 
		[exam['token resultado exame'], exam['data exame'], exam['cpf'], exam['crm médico']])
	end

	def self.type_insert(type, db)
		db.exec('INSERT INTO types(result_token_exam, type, limits_type, result_type) 
		VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING', 
		[type['token resultado exame'], type['tipo exame'], type['limites tipo exame'], type['resultado tipo exame']])
	end
end