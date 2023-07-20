require 'pg'

class Test
  def self.all
    $postgresdb = PG.connect(host: 'postgresdb', user: 'admin', password: 'admin')

    $postgresdb.exec('SELECT patients.cpf, patients.name, patients.email, patients.birth_data, patients.address, patients.city, 
                      patients.state, doctors.crm_doctor, doctors.state_crm_doctor, doctors.name_doctor, 
                      doctors.email_doctor, exams.token, exams.data_exam, exams.type_exam, exams.limit_type_exam, 
                      exams.result_type_exam FROM patients JOIN exams ON exams.patient_id = patients.id JOIN doctors ON doctors.id = exams.doctor_id').to_a 
  end
end