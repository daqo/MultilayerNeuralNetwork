require_relative 'utility'
require_relative 'neural_network'


training_records = Utility.read_csv_file("../data/gameData-normalized.csv")
validation_records = Utility.read_csv_file("../data/gameData-validation-set.csv")

# training_records = Utility.read_csv_file("../data/windsurfData-normalized.csv")
# validation_records = Utility.read_csv_file("../data/windsurfData-validation-set.csv")

multi_layer_neural_network = NeuralNetwork.new(4, 4, 4)
multi_layer_neural_network.train(training_records)

validation_records.each do |r|
  oracle = multi_layer_neural_network.test(r[0])
  puts "Result: #{r[1]}"
  puts "Oracle: #{oracle}"
  puts "****************"
end