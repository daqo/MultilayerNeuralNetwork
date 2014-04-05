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
  end
end