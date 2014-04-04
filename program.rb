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
  #   debugger
  #   error = desired - guess
  #   @weights.each_with_index do |w, i|
  #     @weights[i] += @@learning_factor * error * @inputs[i]
  #   end
  #   puts "After training weights: #{@weights}"
  # end
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

hidden_layer = []
hidden_layer_output = []
#2.times do
  p1 = Perceptron.new([0,1,1], [1,0.5,1])
  hidden_layer << p1
  hidden_layer_output << p1.feedforward

  p2 = Perceptron.new([0,1,1], [-1,2,1])
  hidden_layer << p2
  hidden_layer_output << p2.feedforward
#end

output_layer = []
1.times do
  hidden_layer_output << 1
  output_layer << Perceptron.new(hidden_layer_output, [1.5, -1, 1]).feedforward
end

debugger
puts "DEBUG"

