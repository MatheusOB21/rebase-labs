require_relative 'db'

class Test  
  @@HOST = 'postgresdb'
  @@USER = 'admin'
  @@PASSWORD = 'admin123'  
  @@DBNAME = ''   
  
  if ENV['APP_ENV'] == 'test'
    @@DBNAME = 'test'
  end

  def self.format_json(postgresdb, exams)
    result = exams.map do |exam|
      {
        result_token: exam['result_token'],
        result_date: exam['result_date'],
        patient:{
          cpf: exam['patient_cpf'],
          name: exam['patient_name'],
          email: exam['patient_email'],
          birthday: exam['patient_birth_date'],
          address: exam['patient_address'],
          city: exam['patient_city'],
          state: exam['patient_state'],
        },
        doctor:{
          crm: exam['doctor_crm'],
          crm_state: exam['doctor_state_crm'],
          name: exam['doctor_name'],
        },
        tests: postgresdb.exec('SELECT type, limits_type, result_type FROM types WHERE result_token_exam = $1',[exam['result_token']]).to_a
      }
    end
    postgresdb.close
    result
  end

  def self.all
    postgresdb = PG.connect(host: @@HOST, dbname: @@DBNAME, user: @@USER, password: @@PASSWORD)
    result = DB.select_all_tables(postgresdb).to_a 
    postgresdb.close
    result                 
  end

  def self.all_json
    postgresdb = PG.connect(host: @@HOST, dbname: @@DBNAME, user: @@USER, password: @@PASSWORD)
    exams = postgresdb.exec('SELECT exams.result_token AS result_token, exams.date AS result_date, patients.cpf AS patient_cpf, patients.name AS patient_name, 
                                    patients.email AS patient_email, patients.birth_date AS patient_birth_date, 
                                    patients.address AS patient_address, patients.city AS patient_city, patients.state AS patient_state,
                                    doctors.crm AS doctor_crm, doctors.state_crm AS doctor_state_crm, doctors.name AS doctor_name
                                    FROM exams JOIN patients ON 
                                    patients.cpf = exams.patient_cpf JOIN doctors ON doctors.crm = exams.doctor_crm').to_a                                  
    format_json(postgresdb, exams)
  end

  def self.find(token)
    postgresdb = PG.connect(host: @@HOST, dbname: @@DBNAME, user: @@USER, password: @@PASSWORD)
    exams = postgresdb.exec('SELECT exams.result_token AS result_token, exams.date AS result_date, patients.cpf AS patient_cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birth_date AS patient_birth_date, 
                                    patients.address AS patient_address, patients.city AS patient_city, patients.state AS patient_state,
                                    doctors.crm AS doctor_crm, doctors.state_crm AS doctor_state_crm, doctors.name AS doctor_name
                                    FROM exams JOIN patients ON 
                                    patients.cpf = exams.patient_cpf JOIN doctors ON doctors.crm = exams.doctor_crm WHERE result_token LIKE $1', ["%#{token}%"]).to_a                                 
    format_json(postgresdb, exams)
  end
end