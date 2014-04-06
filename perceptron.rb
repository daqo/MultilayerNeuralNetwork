require 'debugger'
class Perceptron
  attr_accessor :weights, :inputs

  def initialize(inputs, weights = nil)
    #inputs << 1 #Bias
    self.inputs = inputs
    
    if weights.nil?
      @weights = []
      if inputs.nil?
        @inputs = []
      else
        inputs.size.times do 
          @weights << rand(-0.1..0.1)
        end
      end
    else
      @weights = weights
    end
  end

  def feedforward
    sum = 0
    @weights.each_with_index do |w, i|
      sum += @inputs[i] * w
    end
    calculate_estimated_output(sum)
  end

  def calculate_estimated_output(sum)
    1.to_f / (1 + Math::E ** (-1 * sum))
  end
end