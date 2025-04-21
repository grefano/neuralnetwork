mass = 1
hspd = 0
vspd = 0
hacc = 0
vacc = 0 

coef_atrito = .1

died = false
energy = 1




enum E_MOUSEMODES {
	network_resize,
	network_neuron_view,
	gameworld
}
global.mousemode = E_MOUSEMODES.network_resize

width = 64
height = 32


myneuralnetwork = new neural_network(id,
[
	new neuron_input("distx enemy"), new neuron_input("disty enemy"), new neuron_input("energy"), new neuron_input("distx screen"), new neuron_input("disty screen")
],
[
	
	[new neuron_middle(), new neuron_middle(), new neuron_middle()],
	[new neuron_middle(), new neuron_middle()]
	
],
[
	new neuron_output("hspd", 0, function(_val){
		hacc += _val*force_move
	}),
	new neuron_output("hspd", 0,function(_val){
		hacc -= _val*force_move
	}),
	new neuron_output("hspd", 0,function(_val){
		vacc += _val*force_move
	}),
	new neuron_output("hspd", 0, function(_val){
		vacc -= _val*force_move
	})
	
])
draw_network_width = room_width*.3
draw_network_height = room_height*.35
myneuralnetwork.draw_calculate(draw_network_width, draw_network_height)


myneuralnetwork.create_all_neural_connections()


neuron_selected_layer = -1
neuron_selected_index = -1
neuron_act_layer = -1
neuron_act_index = -1


//			Q LEARNING
qtable_sorted = []
myqtable = new Qtable(id)

//new neuron_output("right", 0, ),
	//new neuron_output("left", 0, new NeuronAct),
myqtable.table = create_qtable_actions(
	["right", [ // right
		function(_val, _pass){self.hacc+=_val*force_move*_pass},
		function(_val, _pass){self.hspd+=self.hacc*_pass},
		function(_val, _pass){self.x+=self.hspd*energy*_pass}
	], 0],
	["left", [ // left
		function(_val, _pass){self.hacc-=_val*force_move*_pass},
		function(_val, _pass){self.hspd+=self.hacc*_pass},
		function(_val, _pass){self.x+=self.hspd*energy*_pass}
	], 1],
	["down", [ // down
		function(_val, _pass){self.vacc+=_val*force_move*_pass},
		function(_val, _pass){self.vspd+=self.vacc*_pass},
		function(_val, _pass){self.y+=self.vspd*energy*_pass}
	], 2],
	["up", [ // up
		function(_val, _pass){self.vacc-=_val*force_move*_pass},
		function(_val, _pass){self.vspd+=self.vacc*_pass},
		function(_val, _pass){self.y+=self.vspd*energy*_pass}
	], 3]
	
)

force_move = .8

alarm[0] = 10