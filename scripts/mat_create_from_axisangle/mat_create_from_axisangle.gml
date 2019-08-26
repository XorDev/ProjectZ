/// @description mat_create_from_axisangle(ax, ay, az, angle)
/// @param ax
/// @param ay
/// @param az
/// @param angle
//Creates a rotation matrix
var ax = argument0;
var ay = argument1;
var az = argument2;
var angle = argument3;
var c = dcos(-angle);
var s = dsin(-angle);
var omc = 1 - c;

//Normalise the input vector
var l = sqr(ax) + sqr(ay) + sqr(az);
if l != 1
{
	l = 1 / max(math_get_epsilon(), sqrt(l));
	ax /= l;
	ay /= l;
	az /= l;
}

//Build the rotation matrix
var R = array_create(16, 0);
R[0]  = omc * ax * ax + c;
R[1]  = omc * ax * ay + s * az;
R[2]  = omc * ax * az - s * ay;

R[4]  = omc * ax * ay - s * az;
R[5]  = omc * ay * ay + c;
R[6]  = omc * ay * az + s * ax;

R[8]  = omc * ax * az + s * ay;
R[9]  = omc * ay * az - s * ax;
R[10] = omc * az * az + c;

R[15] = 1;

return R;