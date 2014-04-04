require 'debugger'
require 'ostruct'

class Perceptron
  attr_accessor :weights, :inputs
  @@learning_factor = 0.05

  def initialize(inputs, weights = nil)
    #inputs << 1 #Bias
    self.inputs = inputs

    if weights.nil?
      @weights = []
      inputs.size.times do 
        @weights << rand(-0.5..0.5)
      end
    else
      @weights = weights
    end
    puts "Initial weights: #{@weights}"
  end

  def feedforward
    sum = 0
    @weights.each_with_index do |w, i|
      sum += @inputs[i] * w
    end
    activate(sum)
  end

  def activate(sum)
    1.to_f / (1 + Math::E ** (-1 * sum))
    # sum > 0 ? 1 : -1
  end

  # def train(desired)
  #   guess = feedforward(@inputs)
  #   error = desired - guess
  #   @weights.each_with_index do |w, i|
  #     @weights[i] += @@learning_factor * error * @inputs[i]
  #   end
  #   puts "After training weights: #{@weights}"
  # end
end

class NeuralNetwork
  attr_accessor :hidden_layer, :output_layer, :inputs, :target_value, :output, :hidden_layer_output
  NUM_OF_PERCEPTRON_IN_HIDDEN_LAYER = 2
  NUM_OF_PERCEPTRON_IN_OUTPUT_LAYER = 1

  def initialize(inputs, target_value)
    self.inputs = inputs
    self.target_value = target_value

    train

  end

  def train
    @hidden_layer = []
    @output_layer = []

    @hidden_layer_output = []
    output_layer_output = []

    #2.times do
      p1 = Perceptron.new(@inputs, [1,0.5,1])
      @hidden_layer << p1
      @hidden_layer_output << p1.feedforward

      p2 = Perceptron.new(@inputs, [-1,2,1])
      @hidden_layer << p2
      @hidden_layer_output << p2.feedforward
    #end

    NUM_OF_PERCEPTRON_IN_OUTPUT_LAYER.times do
      @hidden_layer_output << 1 # Bias For Hidden Layer
      p = Perceptron.new(@hidden_layer_output, [1.5, -1, 1])
      @output_layer << p
      output_layer_output << p.feedforward
    end
    @output = max(output_layer, output_layer_output)

    error = calculate_total_error_in_network(@output)
    backpropagate_errors
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

    p @output_layer

    @hidden_layer.each_with_index do |perceptron, j|
      current_weights = perceptron.weights
      current_weights.each_with_index do |w, i|
        current_weights[i] += 0.5 * errors_hidden_units[j] * inputs[i]
      end
    end

    p @hidden_layer
  end

  def calculate_error_for_hidden_units(hidden_layer, hidden_layer_output, error_output)
    errors = []
    hidden_layer.each_with_index do |perceptron, i|
      errors << hidden_layer_output[i] * (1 - hidden_layer_output[i]) * ( @output_layer[0].weights[i] * error_output)
    end
    errors
  end

  def calculate_error_for_output_unit
    @output * (1 - @output) * (@target_value - output)
  end

  def calculate_total_error_in_network(estimated_output)
    0.5 * ((@target_value - estimated_output) ** 2)
  end
end

def health(text)
  case text
  when "Good"
    2
  when "Fair"
    1
  when "Poor"
    0
  end
end

def armor(text)
  text == "Yes" ? 1 : 0
end

def weapon(text)
  text == "Yes" ? 1 : 0
end



test_data = ["Good  No  No  0 Wander",
"Good  No  No  1 Wander",
"Good  No  Yes 1 Attack",
"Good  No  Yes 2 Attack",
"Good  Yes No  2 Hide",
"Good  Yes No  1 Attack",
"Fair  No  No  0 Wander",
"Fair  No  No  1 Hide",
"Fair  No  Yes 1 Attack",
"Fair  No  Yes 2 Hide",
"Fair  Yes No  2 Hide",
"Fair  Yes No  1 Hide",
"Poor  No  No  0 Wander",
"Poor  No  No  1 Hide",
"Poor  No  Yes 1 Hide",
"Poor  No  Yes 2 Run",
"Poor  Yes No  2 Run",
"Poor  Yes No  1 Hide"]

records = []
test_data.each do |data|
  record = OpenStruct.new
  attributes = data.split(" ")
  record.health = health(attributes[0])
  record.armor = armor(attributes[1])
  record.weapon = weapon(attributes[2])
  record.enemies = attributes[3].to_i
  record.oracle = attributes[4]
  records << record
end

NeuralNetwork.new([0,1,1], 1)

