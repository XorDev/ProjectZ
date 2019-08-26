/// @description quat_get_conjugate(Q)
/// @param Q[4]
gml_pragma("forceinline");

var Q = argument0;
Q[0] = -Q[0];
Q[1] = -Q[1];
Q[2] = -Q[2];
return Q;