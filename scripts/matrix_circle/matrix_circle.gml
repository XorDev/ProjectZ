/// @arg x
/// @arg y
/// @arg r
var a = matrix_transform_vertex(matrix_get(matrix_world), 0, 0, 0);
return point_in_circle(mouse_x, mouse_y, a[0] + argument0, a[1] + argument1, argument2);
