/// @description cam_viewmat_get_position(viewMat)
/// @param viewMat
/*
	Returns the position of the camera in world space
	
	Script created by TheSnidr, 2019
*/
var V = argument0;
return [
		- V[12] * V[0] - V[13] * V[1] - V[14] * V[2], 
		- V[12] * V[4] - V[13] * V[5] - V[14] * V[6], 
		- V[12] * V[8] - V[13] * V[9] - V[14] * V[10]];