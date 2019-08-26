/// @description quat_get_si(Q)
/// @param Q[4]
gml_pragma("forceinline");

var Q = argument0;
return [2 * (Q[0] * Q[1] - Q[2] * Q[3]), 
		sqr(Q[3]) - sqr(Q[0]) + sqr(Q[1]) - sqr(Q[2]),
		2 * (Q[1] * Q[2] + Q[0] * Q[3])]