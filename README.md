MultilayerNeuralNetwork
=======================

A neural network, a multilayered perceptron that provides basic intelligence and decision-making ability to a game character.

A collection of training data (consisting of environment/action pairs) is used to train the network to respond appropriately to sets of environmental stimuli. The network should then be able to generalize its behavior such that it can direct a game character to respond appropriately, even to situations it has not encountered before.

You can find the project description in project3.pdf file.
Currently, I'm using sigmoid as the transfer function.
If you wanted to feed other sample to the program, first normalize the data.

Three sample datasets are provided in data/ diectory: 
famous 'wine classification dataset from UC Irvine Machine Learning repository. (http://archive.ics.uci.edu/ml/datasets/Wine)
I normalized that dataset.

Classic windSurf dataset and the last one is a simple decision making dataset for an agent in a strategic game.


