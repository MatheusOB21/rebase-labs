require 'pg'

class Test
  def self.all
    postgresdb = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin')

    postgresdb.exec('SELECT patients.cpf AS cpf, patients.name AS patient_name, patients.email AS patient_email, patients.birth_data 
                      AS patient_birth_data, patients.address AS patient_address, patients.city AS patient_city, patients.state AS patient_state, 
                      doctors.crm AS doctor_crm, doctors.state_crm AS doctor_crm_state, doctors.name AS doctor_name, doctors.email 
                      AS doctor_email, exams.result_token AS exam_result_token, exams.date AS exam_date, exams.type AS exam_type, 
                      exams.limits_type AS limits_exam_type, exams.result_type AS result_exam_type FROM patients JOIN exams ON 
                      exams.patient_id = patients.id JOIN doctors ON doctors.id = exams.doctor_id').to_a 
  end

  def all_json
    postgresdb = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin')
    exams = postgresdb.exec('SELECT * FROM patients JOIN exams ON exams.patient_id = patients.id 
                                           JOIN doctors ON doctors.id = exams.doctor_id').to_a

    exams.map! do |exam| 
      exam.each do |data| 
        "doctor"{
              doctor['crm'], 
              doctor['state_crm'], 
              doctor['name'] },

      end
    end
  end
end