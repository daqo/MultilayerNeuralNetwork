require_relative 'utility'
require_relative 'multi_layer_perceptron'


# training_records = Utility.read_csv_file("../data/game/gameData-normalized.csv")
# validation_records = Utility.read_csv_file("../data/game/gameData-validation-set.csv")
# neural_network = MultiLayerPerceptron.new(4, 4, 4)

# training_records = Utility.read_csv_file("../data/windsurf/windsurfData-normalized.csv")
# validation_records = Utility.read_csv_file("../data/windsurf/windsurfData-validation-set.csv")
# neural_network = MultiLayerPerceptron.new(4, 4, 1)

training_records = Utility.read_csv_file("../data/wine/wine-revised-normalized.csv")
validation_records = Utility.read_csv_file("../data/wine/wine-revised-validation-set.csv")
neural_network = MultiLayerPerceptron.new(13, 4, 3)


def format_oracle(oracle)
  print "Oracle: ["
  oracle.each do |f|
    print "%.3f" % f
    print ' '
  end
  puts ']'
end

neural_network.train(training_records)

validation_records.each do |r|
  oracle = neural_network.test(r[0])
  puts "Result: #{r[1]}"
  #puts "Oracle: #{oracle}"
  format_oracle(oracle)
  puts "****************"
end
