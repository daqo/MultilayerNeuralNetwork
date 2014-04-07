require_relative 'utility'
require_relative 'neural_network'


# training_records = Utility.read_csv_file("../data/game/gameData-normalized.csv")
# validation_records = Utility.read_csv_file("../data/game/gameData-validation-set.csv")
# multi_layer_neural_network = NeuralNetwork.new(4, 9, 4)

# training_records = Utility.read_csv_file("../data/windsurf/windsurfData-normalized.csv")
# validation_records = Utility.read_csv_file("../data/windsurf/windsurfData-validation-set.csv")
# multi_layer_neural_network = NeuralNetwork.new(4, 4, 1)

training_records = Utility.read_csv_file("../data/wine/wine-revised-normalized.csv")
validation_records = Utility.read_csv_file("../data/wine/wine-revised-validation-set.csv")
multi_layer_neural_network = NeuralNetwork.new(13, 4, 3)

1000.times do 
multi_layer_neural_network.train(training_records)
end

validation_records.each do |r|
  oracle = multi_layer_neural_network.test(r[0])
  puts "Result: #{r[1]}"
  puts "Oracle: #{oracle}"
  puts "****************"
end