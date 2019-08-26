/// @description dq_add_translation(DQ, x, y, z)
/// @param DQ[8]
/// @param x
/// @param y
/// @param z
gml_pragma("forceinline");

var Q, T, TR, i;
Q = argument0;

T = [argument1 + 2 * (-Q[7] * Q[0] + Q[4] * Q[3] + Q[6] * Q[1] - Q[5] * Q[2]), 
	argument2 + 2 * (-Q[7] * Q[1] + Q[5] * Q[3] + Q[4] * Q[2] - Q[6] * Q[0]), 
	argument3 + 2 * (-Q[7] * Q[2] + Q[6] * Q[3] + Q[5] * Q[0] - Q[4] * Q[1])];

TR = [	(argument1 + 2 * (-Q[7] * Q[0] + Q[4] * Q[3] + Q[6] * Q[1] - Q[5] * Q[2])) * Q[3] + (argument2 + 2 * (-Q[7] * Q[1] + Q[5] * Q[3] + Q[4] * Q[2] - Q[6] * Q[0])) * Q[2] - (argument3 + 2 * (-Q[7] * Q[2] + Q[6] * Q[3] + Q[5] * Q[0] - Q[4] * Q[1])) * Q[1], 
		T[1] * Q[3] + T[2] * Q[0] - T[0] * Q[2], 
		T[2] * Q[3] + T[0] * Q[1] - T[1] * Q[0], 
		- T[0] * Q[0] - T[1] * Q[1] - T[2] * Q[2]]

TR[0] = argument1 * Q[3] + argument2 * Q[2] + argument3 * Q[1] + 2 * (
	-Q[7] * Q[0] * Q[3] + 
	Q[4] * Q[3] * Q[3] + 
	Q[6] * Q[1] * Q[3] - 
	Q[5] * Q[2] * Q[3] - 
	Q[7] * Q[1] * Q[2] + 
	Q[5] * Q[3] * Q[2] + 
	Q[4] * Q[2] * Q[2] - 
	Q[6] * Q[0] * Q[2] + 
	Q[7] * Q[2] * Q[1] - 
	Q[6] * Q[3] * Q[1] - 
	Q[5] * Q[0] * Q[1] + 
	Q[4] * Q[1] * Q[1]);

for (i = 0; i < 4; i ++)
{
	Q[i + 4] = TR[i] / 2;
}
return Q;