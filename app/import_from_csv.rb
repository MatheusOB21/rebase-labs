require 'pg'
require 'csv'
require_relative 'db'

HOST = 'postgresdb'
USER = 'admin'
PASSWORD = 'admin123'                                

class ImportCSV
  def self.format_csv(csv)
    rows = CSV.parse(csv, col_sep: ';', encoding: "UTF-8")

    columns = rows.shift

    rows.map! do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        
        acc[column] = cell
      end
    end

    rows
  end

  def self.insert_data(params)
    rows = format_csv(params)
    postgresdb = PG.connect(host: HOST, user: USER, password: PASSWORD)
    
    DB.create_tables(postgresdb)       

    rows.each do |row|
      DB.patient_insert(row, postgresdb)
      DB.doctor_insert(row, postgresdb)
      DB.exam_insert(row, postgresdb)
      DB.type_insert(row, postgresdb) 
    end
  end
end