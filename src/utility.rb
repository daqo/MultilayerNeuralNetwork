require 'csv'
class Utility
  def self.read_csv_file(file_path)
    puts "Reading from #{file_path}"
    records_on_file = CSV.read(file_path)
    number_of_attributes = records_on_file.shift[0].split(":")[1].to_i
    number_of_output = records_on_file.shift[0].split(":")[1].to_i
    
    records = records_on_file.map do |r|
      attributes = r.map { |e| e.to_f }
      correct_format = []
      correct_format << attributes[0..number_of_attributes - 1]
      correct_format << attributes[number_of_attributes..number_of_attributes + number_of_output]
      correct_format
    end
  end
end