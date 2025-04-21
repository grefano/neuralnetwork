myqtable.evaluate_qtable()





var qtablerow = myqtable.table[0]
var neuron_index = qtablerow[QTABLE.neuron_index]
var neuronio = myneuralnetwork.output_neurons[neuron_index]
neuronio.func_action(neuronio.val)


myneuralnetwork.back_propagate(neuronio, qtablerow)
