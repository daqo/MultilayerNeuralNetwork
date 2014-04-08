require_relative 'perceptron'

class MultiLayerPerceptron
  attr_accessor :hidden_layer, :output_layer, :inputs, :target_values, :num_of_attributes
  EPOCH_MAX = 1000
  LEARNING_FACTOR = 0.5
  MOMENTUM = 0.9
  DESIRABLE_TOTAL_NETWORK_ERROR = 0.01

  def initialize(num_of_attributes, hidden_layer_perceptron_numbers, output_layer_perceptron_numbers)
    self.num_of_attributes = num_of_attributes

    initialize_hidden_layer(hidden_layer_perceptron_numbers)
    initialize_output_layer(output_layer_perceptron_numbers)
  end

  public

  def train(training_records)
    # EPOCH_MAX.times do |i|
    #   error = 0.0
    #   training_records.each do |r|
    #     error += feed(r[0] << 1, r[1])
    #   end
    #   puts "#{error}" if i % 10 == 0
    # end
    epoch_num = 0
    begin
      epoch_num += 1
      network_error = 0.0
      training_records.each do |r|
        network_error += feed(r[0] << 1, r[1])
      end
      puts "#{network_error}" if epoch_num % 10 == 0
    end while network_error > DESIRABLE_TOTAL_NETWORK_ERROR
    puts "Number of epochs: #{epoch_num}"
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
  def initialize_hidden_layer(perceptron_numbers_in_layer)
    @hidden_layer = []
    perceptron_numbers_in_layer.times do
      perceptron = Perceptron.new
      (@num_of_attributes + 1).times do
        perceptron.weights << Perceptron.random_initial_weight
        perceptron.previous_weights_delta << 0
      end
      @hidden_layer << perceptron
    end
  end

  def initialize_output_layer(perceptron_numbers_in_layer)
    @output_layer = []
    perceptron_numbers_in_layer.times do
      perceptron = Perceptron.new
      (@hidden_layer.size + 1).times do
        perceptron.weights << Perceptron.random_initial_weight
        perceptron.previous_weights_delta << 0
      end
      @output_layer << perceptron
    end
  end

  def feed(record_attributes, target_values)
    self.inputs = record_attributes
    self.target_values = target_values

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

    backpropagate_errors(output_layer_output, hidden_layer_output)
    calculate_total_error_in_network(output_layer_output)
  end

  def backpropagate_errors(output_layer_output, hidden_layer_output)
    output_units_errors = calculate_error_for_output_units(output_units_errors, output_layer_output)
    hidden_units_errors = calculate_error_for_hidden_units(output_units_errors, hidden_layer_output)
    update_network_weights_proportionately(output_units_errors, hidden_units_errors, hidden_layer_output)
  end

  def update_network_weights_proportionately(output_units_errors, hidden_units_errors, hidden_layer_output)
    @output_layer.each_with_index do |perceptron, j|
      perceptron.weights.each_with_index do |w, i|
        delta = LEARNING_FACTOR * output_units_errors[j] * hidden_layer_output[i]
        perceptron.weights[i] += delta
        # Use following two lines if you want to use momentum
        perceptron.weights[i] += MOMENTUM * perceptron.previous_weights_delta[i]
        perceptron.previous_weights_delta[i] = delta
      end
    end

    @hidden_layer.each_with_index do |perceptron, j|
      perceptron.weights.each_with_index do |w, i|
        delta = LEARNING_FACTOR * hidden_units_errors[j] * inputs[i]
        perceptron.weights[i] += delta
        # Use following two lines if you want to use momentum
        perceptron.weights[i] += MOMENTUM * perceptron.previous_weights_delta[i]
        perceptron.previous_weights_delta[i] = delta
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
      output_units_errors << output_layer_output[i] * (1 - output_layer_output[i]) * (@target_values[i] - output_layer_output[i])
    end
    output_units_errors
  end

  def calculate_total_error_in_network(output_layer_output)
    network_error = 0
    @target_values.each_with_index do |t, i|
      network_error += 0.5 * ((t - output_layer_output[i]) ** 2)
    end
    network_error
  end
end
