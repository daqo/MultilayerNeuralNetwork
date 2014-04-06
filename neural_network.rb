require 'debugger'
require_relative 'perceptron'


class NeuralNetwork
  attr_accessor :hidden_layer, :output_layer, :inputs, :target_value, :num_of_perceptron_in_hidden_layer, :num_of_perceptron_in_output_layer, :num_of_attributes
  EPOCH_MAX = 1000

  def initialize(num_of_attributes, hidden_layer_perceptron_numbers, output_layer_perceptron_numbers)
    self.num_of_perceptron_in_hidden_layer = hidden_layer_perceptron_numbers
    self.num_of_perceptron_in_output_layer = output_layer_perceptron_numbers
    self.num_of_attributes = num_of_attributes
    @hidden_layer = []
    @num_of_perceptron_in_hidden_layer.times do
      perceptron = Perceptron.new([])
      (@num_of_attributes + 1).times do
        perceptron.weights << rand(-0.1..0.1)
      end
      @hidden_layer << perceptron
    end

    @output_layer = []
    @num_of_perceptron_in_output_layer.times do
      perceptron = Perceptron.new(nil)
      (@hidden_layer.size + 1).times do
        perceptron.weights << rand(-0.1..0.1)
      end
      @output_layer << perceptron
    end
  end

  def train(training_records)
    training_records.each do |r|
      self.feed(r[0] << 1, r[1])
    end
  end

  def feed(record_attributes, target_value)
    self.inputs = record_attributes
    self.target_value = target_value

    @hidden_layer.each do |perceptron|
      perceptron.inputs = record_attributes
    end

    self.backpropagate
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

    network_errors = calculate_total_errors_in_network(output_layer_output)
    backpropagate_errors(output_layer_output, hidden_layer_output)
    #final_output
  end

  def test(record_attribute)
    self.inputs = record_attribute

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

  def final_output
    estimated_output = @output_layer[0].weights[0] * @output_layer[0].inputs[0] +
      @output_layer[0].weights[1] * @output_layer[0].inputs[1] +
      @output_layer[0].weights[2] * @output_layer[0].inputs[2]
    est = 1.to_f / (1 + Math::E ** (-1 * estimated_output))
    puts "estimated_output: #{est}"
    puts "---------------------------"
  end

  def backpropagate_errors(output_layer_output, hidden_layer_output)
    output_units_errors = calculate_error_for_output_units(output_units_errors, output_layer_output)
    hidden_units_errors = calculate_error_for_hidden_units(output_units_errors, hidden_layer_output)
    update_network_weights_proportionately(output_units_errors, hidden_units_errors, hidden_layer_output)
  end

  def update_network_weights_proportionately(output_units_errors, hidden_units_errors, hidden_layer_output)
    @output_layer.each_with_index do |perceptron, j|
      perceptron.weights.each_with_index do |w, i|
        perceptron.weights[i] += 0.5 * output_units_errors[j] * hidden_layer_output[i]
      end
    end

    @hidden_layer.each_with_index do |perceptron, j|
      perceptron.weights.each_with_index do |w, i|
        perceptron.weights[i] += 0.5 * hidden_units_errors[j] * inputs[i]
      end
    end
  end

  def calculate_error_for_hidden_units(output_units_errors, hidden_layer_output)
    errors = []
    @hidden_layer.each_with_index do |perceptron, i|
      errors << hidden_layer_output[i] * (1 - hidden_layer_output[i]) * ( @output_layer[0].weights[i] * output_units_errors[i])
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

  def calculate_total_errors_in_network(output_layer_output)
    network_errors = []
    @target_value.each_with_index do |t, i|
      network_errors << 0.5 * ((t - output_layer_output[i]) ** 2)
    end
    network_errors
  end
end
