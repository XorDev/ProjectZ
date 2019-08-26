/// @description smf_cast_ray_colmesh_region(colmesh, region, x1, y1, z1, x2, y2, z2)
/// @param colmesh
/// @param region
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
This ray casting script is much, much faster than the regular colmesh raycasting script!
However, it will only cast a ray onto the triangles in the current region, and is as such a "short-range" ray.

Returns an array with the following format:
[x, y, z, normalX, normalY, normalZ, success]

Script made by TheSnidr
www.TheSnidr.com
*/
var retN, success, colMesh, region, x1, y1, z1, x2, y2, z2, lDelta;
colMesh = argument0;
region = argument1;
x1 = argument2;
y1 = argument3;
z1 = argument4;
x2 = argument5;
y2 = argument6;
z2 = argument7;

if is_undefined(region) || region <= 0
{
	return [x1, y1, z1, 0, 0, 1, false];
}

lDelta = [x2 - x1, y2 - y1, z2 - z1];
retN = [0, 0, 0];

success = _cast_ray_colmesh_trilist(region, colMesh[| eColMesh.TriangleList], x1, y1, z1, lDelta, retN, false);
		
return [x1 + lDelta[0], y1 + lDelta[1], z1 + lDelta[2], retN[0], retN[1], retN[2], success];