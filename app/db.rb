require 'pg'

class DB
	def self.select_all_tables(db)
		db.exec('SELECT patients.cpf AS cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birth_date 
			AS patient_birth_date, patients.address AS patient_address, patients.city AS patient_city, patients.state AS patient_state, 
			doctors.crm AS doctor_crm, doctors.state_crm AS doctor_crm_state, doctors.name AS doctor_name, doctors.email 
			AS doctor_email, exams.result_token AS exam_result_token, exams.date AS exam_date, types.type AS exam_type, 
			types.limits_type AS limits_exam_type, types.result_type AS result_exam_type FROM patients JOIN exams ON 
			exams.patient_cpf = patients.cpf JOIN doctors ON doctors.crm = exams.doctor_crm JOIN types ON types.result_token_exam = exams.result_token')
	end

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

	def self.delete_data(db)
		db.exec('DROP TABLE types; DROP TABLE exams; DROP TABLE doctors; DROP TABLE patients;')
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