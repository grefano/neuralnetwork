


//var dir_to_cebero = point_direction(x,y,x+500,y)
var dir_to_cebero = point_direction(x,y,objCebero.x,objCebero.y)
hacc += lengthdir_x(force_move, dir_to_cebero)
vacc += lengthdir_y(force_move, dir_to_cebero)
hacc -= hspd*coef_atrito
vacc -= vspd*coef_atrito


hspd += hacc * global.timespeed
vspd += vacc * global.timespeed

//show_message($"enemy hspd {hspd}/{hspdmax} spd {point_distance(0,0,hspd,vspd)}/{spdmax}")

hacc = 0
vacc = 0

x += hspd * global.timespeed
y += vspd * global.timespeed