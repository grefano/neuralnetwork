
enum QTABLE{
	label,
	predict_act_list,
	neuron_index,
	qvalue
}
function Qtable(_func_eval) constructor{
	table = []
	//func_eval = method(self, _func_eval)
	func_eval = _func_eval
	evaluate_qtable = function(){
		//show_debug_message("eval qtable")
		for(var i = 0; i < array_length(table); i++){
			var q = func_eval(i)
			table[i][QTABLE.qvalue] = q
		}
		array_foreach(table, function(_el, _i){
			//show_debug_message($"{_el[QTABLE.label]}: {_el[QTABLE.qvalue]}")
		})
	}
	
}
function create_qtable_actions(){
	// [label, action_func], [...]
	var qtable = [ ]
	for(var i = 0; i < argument_count; i++){
		var row = argument[i]
		//show_debug_message($"\n row {row[0]} \n")
		array_push(qtable, row)
	}
	return qtable
}


function QPredict(_act_arr, _val, _pass=1){
	if _pass{
		for(var a = 0; a < array_length(_act_arr); a++){
			_act_arr[a](_val, _pass)
		}
	} else {
		for(var a = array_length(_act_arr)-1; a >= 0; a--){
			_act_arr[a](_val, _pass)
		}
	}
		
} 
/*

function NeuronAct(_steps) constructor{
	steps = _steps
	act = function(_val, _pass=1){
		if _pass{
			for(var a = 0; a < array_length(steps); a++){
				steps[a](_val, _pass)
			}
		} else {
			for(var a = array_length(steps)-1; a >= 0; a--){
				steps[a](_val, _pass)
			}
		}
		
	} 
}

/*

function evaluate_qtable(_qtable){
	for(var i = 0; i < array_length(_qtable.table); i++){
		var q = _qtable.func_eval(i)
		_qtable.table[i][QTABLE.qvalue] = q
	}
}

