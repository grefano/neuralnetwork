
function neuron(_label, _bias = 0) constructor{
    label = _label
    input_connections = []
    output_connections = []
    
    bias = _bias
    val = 0
		
    activate = function(){
        var weighted_sum = 0
		var sum_weights = 0
        for(var i = 0; i < array_length(input_connections); i++){
            var connection_value = input_connections[i].get()
            weighted_sum += connection_value
			sum_weights += input_connections[i].weight
        }
		//var _x = 
		val = sigmoid(weighted_sum/sum_weights)+bias
        //val = max(0, weighted_sum/sum_weights+bias)
    }
    
    draw = function(_x, _y, _r){
		var txtscl = min(_r*.04, 1)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_color(make_color_hsv(245, 100, 230))
		draw_circle(_x, _y, _r, false)
		draw_set_color(c_black)
        draw_set_halign(fa_center)
        draw_text_transformed(_x,_y,val, txtscl, txtscl, 0)
        draw_set_valign(fa_middle)
        draw_set_valign(fa_top)
        draw_text_transformed(_x,_y+_r,label, txtscl, txtscl, 0)
    }
}
function neuron_connection(_in_neuron, _out_neuron, _weight = 1) constructor{
    input_neuron = _in_neuron
    output_neuron = _out_neuron
    weight = random_range(-1, 1)
    get = function(){
        return input_neuron.val * weight
    }
}

function neuron_input(_label = "input") : neuron(_label) constructor{}
function neuron_middle(_bias = 0) : neuron("", _bias) constructor{}
function neuron_output(_label = "output", _bias = 0, _func_action) : neuron(_label, _bias) constructor {
	func_action = _func_action
}

function neural_network(_n_input, _n_middle, _n_output) constructor{
    input_neurons = _n_input
    //input_to_l1_connections = []
    middle_neurons = _n_middle
    //ln_to_output_connections = []
    output_neurons = _n_output
    neuron_connections = [] // input-l1[], ...[], ln-output[]
	
	qtd_neuron_columns = 2 + array_length(middle_neurons)
	qtd_rows_max = max(array_length(input_neurons), array_length(output_neurons))
    for(var m = 0; m < array_length(middle_neurons); m++){ 
        qtd_rows_max = max(qtd_rows_max, array_length(middle_neurons[m]))
    }
    
		
    update = function(){
		
        for(var l = 0; l < array_length(middle_neurons); l++){
            for(var m = 0; m < array_length(middle_neurons[l]); m++){
                middle_neurons[l][m].activate()
            }
        }
		for(var o = 0; o < array_length(output_neurons); o++){
			output_neurons[o].activate()	
		}
		
    }
	get_neuron_column_array = function(l){
		if l == 0 return input_neurons;
		if l == qtd_neuron_columns-1 return output_neurons
		return middle_neurons[l-1]
	}
	create_neural_connection = function(in_layer, in_index, out_index){
		//return true
//		//show_debug_message($"{in_layer} {in_index} {out_index} inlayer {array_length(get_neuron_column_array(in_layer))} outlayer {array_length(get_neuron_column_array(in_layer+1))}")
		
		if (in_layer == 0){
//			//show_debug_message($"connection layerin {in_index} layermiddle0 {out_index}")
			array_push(input_neurons[in_index].output_connections, new neuron_connection(input_neurons[in_index], middle_neurons[0][out_index]))
			array_push(middle_neurons[0][out_index].input_connections, new neuron_connection(input_neurons[in_index], middle_neurons[0][out_index]))
		} else {
			if (in_layer == qtd_neuron_columns-2){
//				//show_debug_message($"connection layermiddleN {in_layer-1} {in_index} layerout {out_index}")
				////show_debug_message($"{array_length(middle_neurons[in_layer-1])}")
				array_push(middle_neurons[in_layer-1][in_index].output_connections, new neuron_connection(middle_neurons[in_layer-1][in_index], output_neurons[out_index]))											
				array_push(output_neurons[out_index].input_connections, new neuron_connection(middle_neurons[in_layer-1][in_index], output_neurons[out_index]))											
			} else {
//				//show_debug_message($"connection layermiddle {in_layer-1} {in_index} layermiddle {in_layer} {out_index}")
				array_push(middle_neurons[in_layer-1][in_index].output_connections, new neuron_connection(middle_neurons[in_layer-1][in_index], middle_neurons[in_layer][out_index]))											
				array_push(middle_neurons[in_layer][out_index].input_connections,
				new neuron_connection(middle_neurons[in_layer-1][in_index], middle_neurons[in_layer][out_index]))											
			}
		}
	}
	create_all_neural_connections = function(){
		for(var l =0; l < qtd_neuron_columns-1; l++){
			for(var i = 0; i < array_length(get_neuron_column_array(l)); i++){
				for(var o = 0; o < array_length(get_neuron_column_array(l+1)); o++){
					create_neural_connection(l, i, o)	
				}
			}
		}
	}
    
	
	draw_calculate = function(_width, _height){
	
        _rad = 0
        _sep_x = 0
        _sep_y = 0
        if (_width/qtd_neuron_columns < _height/qtd_rows_max) or true{
            ////show_message("1")
            var _ratio_sepx_rad = 1.5
            var _denominator = (qtd_neuron_columns*2+(qtd_neuron_columns-1)*_ratio_sepx_rad)
            _rad = _width /_denominator
            _sep_x = _rad*_ratio_sepx_rad
            _sep_y = (_height - qtd_rows_max*_rad*2) / (qtd_rows_max-1) + 2*_rad
        } else {
            var _ratio_sepy_rad = 1.5
            var _denominator = (qtd_rows_max*2+(qtd_rows_max-1)*_ratio_sepy_rad)
            _rad = _height /_denominator
            _sep_y = _rad*_ratio_sepy_rad
            _sep_x = (_width - qtd_neuron_columns*_rad*2) / (qtd_neuron_columns-1) + 2*_rad
            //show_debug_message($"rad {_rad} wrest {(_width - qtd_neuron_columns*_rad*2)} sepy {_sep_y} sepx {_sep_x}")
        }
        	
	}
    draw = function(_x_input, _y_input, _sel_col, _sel_row){
        for(var l = 1; l < qtd_neuron_columns; l++){
			if !(l == _sel_col or l-1==_sel_col ) && global.mousemode == E_MOUSEMODES.network_neuron_view continue
            //if (l != 3) continue
			var _in_neuron_array = -1
			var _out_neuron_array = -1
            var _col_in_neuron = l-1 
            if l == 1{   
                _in_neuron_array = input_neurons 
                _out_neuron_array = middle_neurons[l-1]
            } else if l == qtd_neuron_columns-1{
				_in_neuron_array = middle_neurons[l-2]	
				_out_neuron_array = output_neurons
			} else {
				_in_neuron_array = middle_neurons[l-2]	
							//show_debug_message($"layer {l} ")

				_out_neuron_array = middle_neurons[l-1]
			}
			
			
			
			for(var m = 0; m < array_length(_out_neuron_array); m++){
				
                //_out_neuron_array[m].draw(column_x, row_y+_sep_y*m, _rad)
              	//if !(l != 1 or m != 0){
				
				//show_message($"qtd conexoes do neuronio {m} na layer middle {l}: {array_length(middle_neurons[l][m].input_connections)}")
				for(var c = 0; c < array_length(_out_neuron_array[m].input_connections); c++){
                    
                    var _in_connection = _out_neuron_array[m].input_connections[c]
                    var _row_in_neuron = array_get_index(_in_neuron_array, _in_connection.input_neuron)
					
					
					if !((l == _sel_col && m == _sel_row) or (_row_in_neuron == _sel_row && l-1 == _sel_col)) && global.mousemode == E_MOUSEMODES.network_neuron_view continue
										//show_message($"neuronio input conexao: \n col {_col_in_neuron} \n row {_row_in_neuron}")
                    draw_set_color(_in_connection.weight < 0 ? c_red : c_lime)
					var _x1 = _x_input + _col_in_neuron*(_sep_x+2*_rad) + _rad
					var _y1 = _y_input + _row_in_neuron*_sep_y + _rad
					var _x2 = _x1+_sep_x+2*_rad
					var _y2 = _y_input+_rad+m*_sep_y
					draw_set_alpha(abs(_in_connection.weight) < .2 ? abs(_in_connection.weight) : 1)
                    draw_line_width(_x1, _y1, _x2, _y2, abs(_in_connection.weight*_rad*.2))
					draw_set_alpha(1)
					draw_set_halign(fa_center)
					draw_set_valign(fa_bottom)
					//draw_text((_x1+_x2)/2, (_y1+_y2)/2, _in_connection.weight)
				}
								//}
            }
            //column_x += 2*_rad + _sep_x

        }
        
        var column_x = _x_input+_rad
        var row_y = _y_input+_rad
        for(var i = 0; i < array_length(input_neurons); i++){
            if !(_sel_col == 0 && _sel_row == i)  && global.mousemode == E_MOUSEMODES.network_neuron_view continue
			input_neurons[i].draw(column_x, row_y+_sep_y*i, _rad)
        }
        
        column_x += 2*_rad + _sep_x
        for(var l = 0; l < array_length(middle_neurons); l++){				
			for(var m = 0; m < array_length(middle_neurons[l]); m++){				
				if !(_sel_col < qtd_neuron_columns-1 && _sel_col-1 == l && _sel_row == m)  && global.mousemode == E_MOUSEMODES.network_neuron_view continue
				middle_neurons[l][m].draw(column_x, row_y+_sep_y*m, _rad)
			}
			column_x += 2*_rad + _sep_x

		}
		
		for(var i = 0; i < array_length(output_neurons); i++){
			if !(_sel_col == qtd_neuron_columns-1 && _sel_row == i) && global.mousemode == E_MOUSEMODES.network_neuron_view continue
            if (objCebero.neuron_act_index == i) draw_circle_color(column_x, row_y+_sep_y*i, _rad*1.25, c_lime, c_lime, false)
			output_neurons[i].draw(column_x, row_y+_sep_y*i, _rad)
        }
		
		
        
        draw_set_color(c_red)        
        //draw_rectangle(_x_input, _y_input, _x_input+_width, _y_input+_height,true)

    }
}


function sigmoid(_x){
	var euler = 2.718281828459045
	return 1/ (1 + power(euler, -_x))
}