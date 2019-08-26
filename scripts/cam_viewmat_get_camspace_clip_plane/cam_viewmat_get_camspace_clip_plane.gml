/// @description cam_viewmat_get_camspace_clip_plane(viewMat, px, py, pz, nx, ny, nz)
/// @param viewMat
/// @param px
/// @param py
/// @param pz
/// @param nx
/// @param ny
/// @param nz
/*
	Supply the world-space coordinates and normal of the clip plane
	Returns a 4D array containing the vector of the desired camera-space clip plane.
	
	Script created by TheSnidr, 2019
*/
var V = argument0;
var Wx = argument1;
var Wy = argument2;
var Wz = argument3;
var Nx = argument4;
var Ny = argument5;
var Nz = argument6;

//Find a camera-space position on the plane (it does not matter where on the clip plane, as long as it is on it)
//Wx, Wy, Wz is the world-space plane coordinate
var Px, Py, Pz;
Px = V[0] * Wx + V[4] * Wy + V[8] * Wz + V[12];
Py = V[1] * Wx + V[5] * Wy + V[9] * Wz + V[13];
Pz = V[2] * Wx + V[6] * Wy + V[10]* Wz + V[14];

//Find the camera-space 4D reflection plane vector
//Nx, Ny, Nz is the world-space normal of the plane
var Cx, Cy, Cz, Cw;
Cx = V[0] * Nx + V[4] * Ny + V[8] * Nz;
Cy = V[1] * Nx + V[5] * Ny + V[9] * Nz;
Cz = V[2] * Nx + V[6] * Ny + V[10]* Nz;
Cw = - Cx * Px - Cy * Py - Cz * Pz;

return [Cx, Cy, Cz, Cw];