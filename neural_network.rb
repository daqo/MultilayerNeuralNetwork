require 'debugger'
require_relative 'perceptron'


class NeuralNetwork
  attr_accessor :hidden_layer, :output_layer, :inputs, :target_value, :output, :hidden_layer_output
  NUM_OF_PERCEPTRON_IN_HIDDEN_LAYER = 2
  NUM_OF_PERCEPTRON_IN_OUTPUT_LAYER = 1

  def initialize(inputs, target_value)
    self.inputs = inputs
    self.target_value = target_value
    @hidden_layer = []
    @hidden_layer << Perceptron.new(@inputs, [1,0.5,1])
    @hidden_layer << Perceptron.new(@inputs, [-1,2,1])

    @output_layer = []
    @output_layer << Perceptron.new(nil, [1.5, -1, 1])

    1000.times { 
      train
      final_output
    }

  end

  def train
    @hidden_layer_output = []
    output_layer_output = []


    @hidden_layer.each do |p|
      @hidden_layer_output << p.feedforward
    end

    @hidden_layer_output << 1 # Bias For Hidden Layer

    @output_layer.each do |p|
      p.inputs = @hidden_layer_output
      output_layer_output << p.feedforward
    end
    @output = max(output_layer, output_layer_output)

    error = calculate_total_error_in_network(@output)
    backpropagate_errors
  end

  def final_output
    estimated_output = @output_layer[0].weights[0] * @output_layer[0].inputs[0] +
                        @output_layer[0].weights[1] * @output_layer[0].inputs[1] +
                        @output_layer[0].weights[2] * @output_layer[0].inputs[2]
    est = 1.to_f / (1 + Math::E ** (-1 * estimated_output))
    puts "estimated_output: #{est}"
    puts "---------------------------"
  end

  def max(output_layer, output_layer_output)
    output_layer_output.first
  end

  def backpropagate_errors
    error_output = calculate_error_for_output_unit
    errors_hidden_units = calculate_error_for_hidden_units(@hidden_layer, @hidden_layer_output, error_output)
    update_network_weights_proportionately(error_output, errors_hidden_units)
  end

  def update_network_weights_proportionately(error_output, errors_hidden_units)
    @output_layer.each do |perceptron|
      current_weights = perceptron.weights
      current_weights.each_with_index do |www, i|
        current_weights[i] += 0.5 * error_output * @hidden_layer_output[i]
      end
    end

    @hidden_layer.each_with_index do |perceptron, j|
      current_weights = perceptron.weights
      current_weights.each_with_index do |w, i|
        current_weights[i] += 0.5 * errors_hidden_units[j] * inputs[i]
      end
    end

    # puts "hidden layer:"
    # p @hidden_layer
    # puts "---------------------------"
  end

  def calculate_error_for_hidden_units(hidden_layer, hidden_layer_output, error_output)
    errors = []
    hidden_layer.each_with_index do |perceptron, i|
      errors << hidden_layer_output[i] * (1 - hidden_layer_output[i]) * ( @output_layer[0].weights[i] * error_output)
    end
    errors
  end

  def calculate_error_for_output_unit
    @output * (1 - @output) * (@target_value - @output)
  end

  def calculate_total_error_in_network(estimated_output)
    0.5 * ((@target_value - estimated_output) ** 2)
  end
end