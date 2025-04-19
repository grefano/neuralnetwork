
draw_set_color(c_fuchsia)
draw_roundrect_ext(x-15,y-10,x+15,y+10,20,15,false)

myneuralnetwork.draw(20, 20, neuron_selected_layer, neuron_selected_index)
draw_set_color(c_red)
draw_rectangle(20,20,20+draw_network_width, 20+draw_network_height, true)
draw_set_color(c_black)
draw_text(mouse_x, mouse_y, $"col {neuron_selected_layer} row {neuron_selected_index}")

draw_set_halign(fa_right)

draw_text(room_width-30,10,global.timespeed)
draw_text(room_width-30,30,energy)

draw_set_halign(fa_left)