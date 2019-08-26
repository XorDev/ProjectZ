/// @description smf_vector_distance(u, v)
/// @param u
/// @param v
gml_pragma("forceinline");
var u, v;
u = argument0;
v = argument1;
return point_distance_3d(u[0], u[1], u[2], v[0], v[1], v[2]);