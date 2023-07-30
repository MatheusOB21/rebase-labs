require 'csv'
require_relative 'db'
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

  def self.create_tables(postgresdb)
    DB.create_tables(postgresdb)   
  end

  def self.insert_data(params, postgresdb)
    rows = format_csv(params)    
    rows.each do |row|
      DB.patient_insert(row, postgresdb)
      DB.doctor_insert(row, postgresdb)
      DB.exam_insert(row, postgresdb)
      DB.type_insert(row, postgresdb) 
    end
  end
end