require 'pg'

class Test
  HOST = 'postgresdb'
  USER = 'admin'
  PASSWORD = 'admin123'

  def self.format_json(postgresdb, exams)
    exams.map do |exam|
      {
        result_token: exam['result_token'],
        result_date: exam['result_date'],
        cpf: exam['patient_cpf'],
        name: exam['patient_name'],
        email: exam['patient_email'],
        birthday: exam['patient_birth_date'],
        doctor:{
          crm: exam['doctor_crm'],
          crm_state: exam['doctor_state_crm'],
          name: exam['doctor_name'],
        },
        tests: postgresdb.exec('SELECT type, limits_type, result_type FROM types WHERE result_token_exam = $1',[exam['result_token']]).to_a
      }
    end
  end

  def self.all
    postgresdb = PG.connect(host: HOST, user: USER, password: PASSWORD)
    postgresdb.exec('SELECT patients.cpf AS cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birth_date 
                      AS patient_birth_date, patients.address AS patient_address, patients.city AS patient_city, patients.state AS patient_state, 
                      doctors.crm AS doctor_crm, doctors.state_crm AS doctor_crm_state, doctors.name AS doctor_name, doctors.email 
                      AS doctor_email, exams.result_token AS exam_result_token, exams.date AS exam_date, types.type AS exam_type, 
                      types.limits_type AS limits_exam_type, types.result_type AS result_exam_type FROM patients JOIN exams ON 
                      exams.patient_id = patients.id JOIN doctors ON doctors.id = exams.doctor_id JOIN types ON types.result_token_exam = exams.result_token').to_a 
  end

  def self.all_json
    postgresdb = PG.connect(host: HOST, user: USER, password: PASSWORD)
    exams = postgresdb.exec('SELECT exams.result_token AS result_token, exams.date AS result_date, patients.cpf AS patient_cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birth_date AS patient_birth_date, 
                                    doctors.crm AS doctor_crm, doctors.state_crm AS doctor_state_crm, doctors.name AS doctor_name
                                    FROM exams JOIN patients ON 
                                    patients.id = exams.patient_id JOIN doctors ON doctors.id = exams.doctor_id').to_a
    format_json(postgresdb, exams)
  end

  def self.find(token)
    postgresdb = PG.connect(host: HOST, user: USER, password: PASSWORD)
    exams = postgresdb.exec('SELECT exams.result_token AS result_token, exams.date AS result_date, patients.cpf AS patient_cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birth_date AS patient_birth_date, 
                                    doctors.crm AS doctor_crm, doctors.state_crm AS doctor_state_crm, doctors.name AS doctor_name
                                    FROM exams JOIN patients ON 
                                    patients.id = exams.patient_id JOIN doctors ON doctors.id = exams.doctor_id WHERE result_token = $1', [token]).to_a
    format_json(postgresdb, exams)
  end
end