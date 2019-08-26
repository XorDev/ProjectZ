/// @description cam_set_viewmat(camera, xFrom, yFrom, zFrom, xTarget, yTarget, zTarget, xUp, yUp, zUp)
/// @param camera
/// @param xFrom
/// @param yFrom
/// @param zFrom
/// @param xTarget
/// @param yTarget
/// @param zTarget
/// @param xUp
/// @param yUp
/// @param zUp
var camera = argument0;
camera_set_view_mat(camera, matrix_build_lookat(argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9));