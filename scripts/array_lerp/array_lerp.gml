/// @description array_lerp(array1, array2, amount)
/// @param array1
/// @param array2-
/// @param amount
/*
	Linearly interpolates between two arrays.
	The arrays must be of the same length.
	
	Script created by TheSnidr
*/
var ar1 = argument0;
var ar2 = argument1;
var t = argument2;
var t1 = 1 - t;

var i = array_length_1d(ar1);
var ret = array_create(i);
while i--
{
	ret[i] = ar1[i] * t + ar2[i] * t1;
}

return ret;