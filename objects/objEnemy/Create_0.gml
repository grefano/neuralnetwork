
var _dirspawn = 125
x = objCebero.x + lengthdir_x(room_width*.25, _dirspawn)
y = objCebero.y + lengthdir_y(room_height*.25, _dirspawn)

hspd = 0
hacc = 0
vspd = 0
vacc = 0

coef_atrito = .025
force_move = objCebero.force_move*.25

hspdmax = force_move / coef_atrito
spdmax = sqrt(power(hspdmax, 2)*2)
//show_message(spdmax)