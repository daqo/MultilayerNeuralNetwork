class Perceptron
  attr_accessor :weights, :inputs, :previous_weights_delta

  def initialize
    @inputs = []
    @weights = []
    # Use previous_weights_delta to hold previous change in weight
    # We will use it for adding momentum.
    @previous_weights_delta = []
  end

  def feedforward
    sum = 0
    @weights.each_with_index do |ww, i|
      sum += @inputs[i] * ww
    end
    calculate_estimated_output(sum)
  end

  def calculate_estimated_output(sum)
    1.to_f / (1 + Math::E ** (-1 * sum))
  end

  def self.random_initial_weight
    rand(-0.1..0.1)
  end
end