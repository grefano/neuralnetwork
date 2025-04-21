
enum QTABLE{
	label,
	predict_act_list,
	neuron_index,
	qvalue
}
function Qtable(_owner) constructor{
	owner = _owner
	table = []
	//func_eval = method(self, _func_eval)
	func_eval = function(i){
		var table_row = other.table[i]
		var qneuron = owner.myneuralnetwork.output_neurons[i]

		q_act_predict(table_row[QTABLE.predict_act_list], qneuron.val, 1)
		var q = q_get()
		q_act_predict(table_row[QTABLE.predict_act_list], qneuron.val, -1)

		return q
	}
	evaluate_qtable = function(){
		//show_debug_message("eval qtable")
		for(var i = 0; i < array_length(table); i++){
			var q = func_eval(i)
			table[i][QTABLE.qvalue] = q
		}
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
function Qcalc() constructor{
	points_calc = []
	get = function(){
		var q = 0
		for(var i = 0; i < array_length(points_calc); i++){
			q += points_calc[i]()
		}
		return q
	}
}

function q_get(){
	var q = 0
	var rate_dist_enemy = .005
	var rate_dist_screen = .05
	
	//var target_x = objEnemy.x
	//var target_y = objEnemy.y
	
	target_x = room_width/2
	target_y = room_height/2
	
	var _distenemy =point_distance(self.owner.x, self.owner.y, target_x, target_y)*rate_dist_enemy
 	q += _distenemy
	var _distscreenx = abs(room_width/2 - self.owner.x) > global.safearea_width/2 ? abs(room_width/2-self.owner.x)-global.safearea_width/2 : 0
	var _distscreeny = abs(room_height/2 - self.owner.y) > global.safearea_height/2 ? abs(room_height/2-self.owner.y)-global.safearea_height/2 : 0
	q -= _distscreenx*rate_dist_screen
	q -= _distscreeny*rate_dist_screen
	return q
}
function q_variation_from_output(_pos, _enemy_pos){
	if (_pos < _enemy_pos){
		return -.005
	} else if (_pos > _enemy_pos){
		return .005
	} else {
		return undefined
	}
}
function loss_get(_result_predicted, _result_real){
	return power(_result_predicted - _result_real, 2)
}
function get_output_variation_from_q(qwant, qreal){ // Qreal
	
	
	// essa função serve para usar o Qreal e descobrir o output do neuronio
	// -> weigthed sum -> OUTPUT -> acc -> spd -> pos -> Q_PREDICT -> -> LOSS
	//                 <- OUTPUT <- acc <- spd <- pos <- Q_REAL    -> /
	//                       `--<-----------------------<--´
	// x = x + hspd + output*force_move
	// em um estado (posições fixas), existe uma taxa de variação do OUTPUT q resulta em uma variação no Q?
	// 
	//var targetx = objEnemy.x
	targetx = room_width/2
	var Qvariation = q_variation_from_output(self.owner.x, targetx)
	if (Qvariation == undefined) return 0
			var rate_learn = .0005
	return 1/Qvariation * rate_learn
}

function q_act_predict(_act_arr, _val, _pass=1){
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

