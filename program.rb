require 'ostruct'
require_relative 'neural_network'

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

