/// @description quat_create(angle, ax, ay, az,)
/// @param angle
/// @param ax
/// @param ay
/// @param az
//Creates a quaternion from axis angle
gml_pragma("forceinline");
argument0 /= 2;
var s = sin(argument0);
return [argument1 * s, argument2 * s, argument3 * s, cos(argument0)];