global.mousemode = E_MOUSEMODES.gameworld
if mouse_check_button(mb_left) global.mousemode = E_MOUSEMODES.network_resize
if mouse_check_button(mb_right) global.mousemode = E_MOUSEMODES.network_neuron_view

global.timespeed += (keyboard_check_pressed(vk_f10)-keyboard_check_pressed(vk_f9))*.25

switch(global.mousemode){
	case E_MOUSEMODES.network_resize:
		draw_network_width = mouse_x-20
		draw_network_height = mouse_y-20
		myneuralnetwork.draw_calculate(draw_network_width, draw_network_height)
	break;
	case E_MOUSEMODES.network_neuron_view:
		neuron_selected_layer = floor((mouse_x-20)/(myneuralnetwork._sep_x+myneuralnetwork._rad*2))
		neuron_selected_index = floor((mouse_y-20)/(myneuralnetwork._sep_y))
	break;
	case E_MOUSEMODES.gameworld:
		
	break;
}


myneuralnetwork.input_neurons[0].val = (objEnemy.x-x)/room_height
myneuralnetwork.input_neurons[1].val = (objEnemy.y-y)/room_height
myneuralnetwork.input_neurons[2].val = energy
var _distx = x-room_width/2
//myneuralnetwork.input_neurons[3].val = abs(_distx) > (global.safearea_width/2) ? _distx-sign(_distx)*(global.safearea_width/2) : 0 
var _disty = y-room_height/2
//myneuralnetwork.input_neurons[4].val = abs(_disty) > (global.safearea_height/2) ? _disty-sign(_disty)*(global.safearea_height/2) : 0
myneuralnetwork.input_neurons[3].val = x-room_width/2
myneuralnetwork.input_neurons[4].val = y-room_height/2


myneuralnetwork.update()

//show_debug_message("table:")

////show_debug_message($"{myqtable.table[0][0]}")

myqtable.evaluate_qtable()

//myneuralnetwork.output_neurons[0].func_action(myneuralnetwork.output_neurons[0].val)
//myneuralnetwork.output_neurons[1].func_action(myneuralnetwork.output_neurons[1].val)
// act
if array_length(qtable_sorted) > 0{
	var neuronio = myneuralnetwork.output_neurons[qtable_sorted[0][QTABLE.neuron_index]]
	neuronio.func_action(neuronio.val)
	neuron_act_index = array_get_index(myneuralnetwork.output_neurons, neuronio)

	if alarm[0] == 10{
		var q = q_get()	
		var qpredict = qtable_sorted[0][QTABLE.qvalue]
		
		var loss = loss_get(qpredict, q)
		var gradient = 2 * (qpredict - q) // loss / a
		var qwant = qpredict + gradient
		var lossnew = loss_get(qwant, q)
		show_message($"qpredict {qpredict} - qreal {q} = loss {string_format(loss, 1, 5)}")
		show_message($"quanto output tem q mudar pro loss ser 0: {string_format(gradient, 1, 5)}")
		show_message($"novo loss {string_format(lossnew, 1, 5)}") // deveria ser 0
		
		
		
	}
}
//hacc += myneuralnetwork.output_neurons[0].val * energy
//vacc += myneuralnetwork.output_neurons[1].val * energy

hacc -= hspd*coef_atrito
vacc -= vspd*coef_atrito

hspd += hacc/mass * global.timespeed
vspd += vacc/mass * global.timespeed
x += hspd * energy * global.timespeed
y += vspd * energy * global.timespeed
hacc = 0
vacc = 0

var _spd = point_distance(0,0,hspd,vspd)
var kenergygain = 1/120
var spdthreshold = objEnemy.spdmax * .4 // velocidade que quando atingida faz a energia diminuir
var kenergy = kenergygain/power(spdthreshold,2)
var denergy = -power(_spd, 2)*kenergy + kenergygain // _spd^2 * kenergy  = kenergygain
energy += denergy
energy = clamp(energy, 0, 1)
show_debug_message($"delta energy {denergy}")
show_debug_message($"{_spd > spdthreshold?"correndo":"suave"} spd {_spd} kenergy {kenergy}")

var spdmax = force_move / coef_atrito
//show_message(spdmax)
// spdmax > enemy.spdmax
// se spd > enemy.spdmax: perde energia
//		spd == enemy.spdmax     power(spd, 2)*kenergy = 1/120        kenergy = 1/(120*objEnemy.spdmax^2)

if energy <= 0 {
    died = true
}

if keyboard_check_pressed(ord("R")) room_restart()