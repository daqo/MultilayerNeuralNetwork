require 'debugger'
require_relative 'perceptron'


class NeuralNetwork
  attr_accessor :dool, :hidden_layer, :output_layer, :inputs, :target_value, :num_of_perceptron_in_hidden_layer, :num_of_perceptron_in_output_layer, :num_of_attributes
  EPOCH_MAX = 1000
  LEARNING_FACTOR = 0.5

  def initialize(num_of_attributes, hidden_layer_perceptron_numbers, output_layer_perceptron_numbers)
    self.num_of_perceptron_in_hidden_layer = hidden_layer_perceptron_numbers
    self.num_of_perceptron_in_output_layer = output_layer_perceptron_numbers
    self.num_of_attributes = num_of_attributes

    initialize_hidden_layer
    initialize_output_layer
  end

  public

  def train(training_records)
    epoch_count = 0
    begin
      training_records.each do |r|
        feed(r[0] << 1, r[1])
      end
      epoch_count += 1
    end while calculate_total_error_in_network(dool) > 0.01
    puts "EPOCH Count: #{epoch_count}"
  end

  def test(record_attribute)
    self.inputs = record_attribute << 1

    @hidden_layer.each do |p|
      p.inputs = self.inputs
    end

    hidden_layer_output = []
    output_layer_output = []

    @hidden_layer.each do |p|
      hidden_layer_output << p.feedforward
    end

    hidden_layer_output << 1 # Bias For Hidden Layer

    @output_layer.each do |p|
      p.inputs = hidden_layer_output
      output_layer_output << p.feedforward
    end

    output_layer_output
  end

  private
  def initialize_hidden_layer
    @hidden_layer = []
    @num_of_perceptron_in_hidden_layer.times do
      perceptron = Perceptron.new
      (@num_of_attributes + 1).times do
        perceptron.weights << Perceptron.random_initial_weight
      end
      @hidden_layer << perceptron
    end
  end

  def initialize_output_layer
    @output_layer = []
    @num_of_perceptron_in_output_layer.times do
      perceptron = Perceptron.new
      (@hidden_layer.size + 1).times do
        perceptron.weights << Perceptron.random_initial_weight
      end
      @output_layer << perceptron
    end
  end

  def feed(record_attributes, target_value)
    self.inputs = record_attributes
    self.target_value = target_value

    @hidden_layer.each do |perceptron|
      perceptron.inputs = self.inputs
    end

    backpropagate
  end

  def backpropagate
    hidden_layer_output = []
    output_layer_output = []

    @hidden_layer.each do |p|
      hidden_layer_output << p.feedforward
    end

    hidden_layer_output << 1 # Bias For Hidden Layer

    @output_layer.each do |p|
      p.inputs = hidden_layer_output
      output_layer_output << p.feedforward
    end

    @dool = output_layer_output

    backpropagate_errors(output_layer_output, hidden_layer_output)
  end

  def backpropagate_errors(output_layer_output, hidden_layer_output)
    output_units_errors = calculate_error_for_output_units(output_units_errors, output_layer_output)
    hidden_units_errors = calculate_error_for_hidden_units(output_units_errors, hidden_layer_output)
    update_network_weights_proportionately(output_units_errors, hidden_units_errors, hidden_layer_output)
  end

  def update_network_weights_proportionately(output_units_errors, hidden_units_errors, hidden_layer_output)
    @output_layer.each_with_index do |perceptron, j|
      perceptron.weights.each_with_index do |w, i|
        perceptron.weights[i] += LEARNING_FACTOR * output_units_errors[j] * hidden_layer_output[i]
      end
    end

    @hidden_layer.each_with_index do |perceptron, j|
      perceptron.weights.each_with_index do |w, i|
        perceptron.weights[i] += LEARNING_FACTOR * hidden_units_errors[j] * inputs[i]
      end
    end
  end

  def calculate_error_for_hidden_units(output_units_errors, hidden_layer_output)
    errors = []
    @hidden_layer.each_with_index do |perceptron, i|

      sum = 0
      @output_layer.each_with_index do |output_perceptron, j|
        sum +=  output_perceptron.weights[i] * output_units_errors[j]
      end

      errors << hidden_layer_output[i] * (1 - hidden_layer_output[i]) * sum
    end
    errors
  end

  def calculate_error_for_output_units(output_units_errors, output_layer_output)
    output_units_errors = []
    @output_layer.each_with_index do |p, i|
      output_units_errors << output_layer_output[i] * (1 - output_layer_output[i]) * (@target_value[i] - output_layer_output[i])
    end
    output_units_errors
  end

  def calculate_total_error_in_network(output_layer_output)
    network_error = 0
    @target_value.each_with_index do |t, i|
      network_error += 0.5 * ((t - output_layer_output[i]) ** 2)
    end
    network_error
  end
end
