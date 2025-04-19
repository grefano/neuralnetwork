qtable_sorted = []
array_copy(qtable_sorted, 0, myqtable.table, 0, array_length(myqtable.table))

array_sort(qtable_sorted, function(_el1, _el2){
	return (_el1[QTABLE.qvalue] - _el2[QTABLE.qvalue]) < 0
})




alarm[0] = 10 

