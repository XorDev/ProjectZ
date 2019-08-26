/// @description smf_sphere_avoid_colmesh_fast(colmesh, x, y, z, radius)
/// @param colmesh
/// @param x
/// @param y
/// @param z
/// @param radius
/*
Fast colision script, not taking the order of collisions into account
Pushes a sphere at [x, y, z] with a given radius out of a collision mesh.
It checks the potential collision triangles in two passes:
	The first pass sorts through all triangles in the region, and checks if there is a potential collision. If there is, the triangle is added to a ds_priority based on the potential displacement of the sphere
	The second pass makes the sphere avoid triangles, starting with the triangles that cause the greatest displacement.

Returns an array of the following format:
[x, y, z, Nx, Ny, Nz, collision (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
/////////////////////////
//Load arguments
var colMesh, newX, newY, newZ, R, region;
colMesh = argument0;
newX = argument1;
newY = argument2;
newZ = argument3;
R = argument4;

region = colmesh_get_region(colMesh, newX, newY, newZ);
return sphere_avoid_colmesh_fast_region(colMesh, region, newX, newY, newZ, R);