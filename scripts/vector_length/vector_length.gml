/// @description vector_length(u)
/// @param u
gml_pragma("forceinline");
var u;
u = argument0;
return point_distance_3d(u[0], u[1], u[2], 0, 0, 0);