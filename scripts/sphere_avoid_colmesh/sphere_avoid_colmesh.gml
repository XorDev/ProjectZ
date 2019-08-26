/// @description smf_sphere_avoid_colmesh(colmesh, x, y, z, radius, xup, yup, zup, slope(degrees))
/// @param colmesh
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param xup
/// @param yup
/// @param zup
/// @param slope(degrees)
/*
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
//Create collision sphere
var colMesh, newX, newY, newZ, xup, yup, zup, R, slopeAngle;
colMesh = argument0;
newX = argument1;
newY = argument2;
newZ = argument3;
R = argument4;
xup = argument5;
yup = argument6;
zup = argument7;
slopeAngle = argument8;

/////////////////////////////////////////////////////////////////////////////////////////////
//Find region and perform collisions with this region
var region = colmesh_get_region(colMesh, newX, newY, newZ);
return sphere_avoid_colmesh_region(colMesh, region, newX, newY, newZ, R, xup, yup, zup, slopeAngle);