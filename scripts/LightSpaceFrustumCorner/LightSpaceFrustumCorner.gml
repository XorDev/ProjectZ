/// @arg {float3} start
/// @arg {float3} dir
/// @arg {float1} width
var start = argument0;
var dir   = argument1;
var width = argument2;

return matrix_transform_vertex_4(mView, 
    [
        start[0] + dir[0] * width, 
        start[1] + dir[1] * width, 
        start[2] + dir[2] * width, 
        1
    ]
);
