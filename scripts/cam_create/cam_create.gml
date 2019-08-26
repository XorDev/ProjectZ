/// @description cam_create(view, FOV, aspect, near, far)
/// @param view_index
/// @param FOV
/// @param aspect
/// @param near
/// @param far
/*
	Creates a camera for the given view
	If view is -1, the camera is not assigned to any views. This is useful for for example shadow maps.

	Script created by TheSnidr
	www.thesnidr.com
*/
var viewInd = argument0;
var FOV = argument1;
var aspect = argument2;
var near = argument3;
var far = argument4;

var camera = camera_create();
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-FOV, -aspect, near, far));

if viewInd >= 0
{
	view_enabled = true;
	view_set_visible(viewInd, true);
	view_set_camera(viewInd, camera);
}

return camera;