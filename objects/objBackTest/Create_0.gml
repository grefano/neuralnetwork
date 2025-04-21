
global.mousemode = E_MOUSEMODES.gameworld


// network
myneuralnetwork = new neural_network(id,
[
	new neuron_input("input")
],
[
	[new neuron_middle()],
	[new neuron_middle()]
],
[
	new neuron_output("output", 0, function(_val){
		x += _val
	})
])

myneuralnetwork.create_all_neural_connections()

draw_network_width = room_width*.3
draw_network_height = room_height*.35
myneuralnetwork.draw_calculate(draw_network_width, draw_network_height)



myqtable = new Qtable(id)
myqtable.table = create_qtable_actions(
	["right", [
		function(_val, _pass){self.x+=_val*_pass}
	], 0]
)