require 'csv'
class Utility
  def self.read_csv_file(file_path)
    records_on_file = CSV.read(file_path)

    records = records_on_file.map do |r|
      attributes = r.map { |e| e.to_f }
      correct_format = []
      correct_format << attributes[0..3]
      correct_format << attributes[4..7]
      correct_format
    end
  end
end