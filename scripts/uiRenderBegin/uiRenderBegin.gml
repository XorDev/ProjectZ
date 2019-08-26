/// @arg xoff
/// @arg yoff
/// @arg active
__uiMX = argument2 * (device_mouse_x_to_gui(0) - argument0);
__uiMY = argument2 * (device_mouse_y_to_gui(0) - argument1);

__uiProj = matrix_get(matrix_projection);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
matrix_set(matrix_projection, matrix_build_projection_ortho(WIDTH, -HEIGHT, -10, 100));
__uiClickZ = 0;
__uiOrientation = uiFlags.Null;

SV_CalcMouseDelta; // Calculate mouse delta

