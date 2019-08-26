/// @description cast_ray_plane(px, py, pz, nx, ny, nz, x1, y1, z1, x2, y2, z2)
/// @param px
/// @param py
/// @param pz
/// @param nx
/// @param ny
/// @param nz
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
	Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a plane at (px, py, pz) with normal (nx, ny, nz).

	Returns the intersection as an array of the following format:
	[x, y, z, nx, ny, nz, intersection (true or false)]

	Script made by TheSnidr

	www.thesnidr.com
*/
var px, py, pz, nx, ny, nz;
px = argument0;
py = argument1;
pz = argument2;
nx = argument3;
ny = argument4;
nz = argument5;

var x1, y1, z1;
x1 = argument6;
y1 = argument7;
z1 = argument8;

var x2, y2, z2;
x2 = argument9;
y2 = argument10;
z2 = argument11;

var dx, dy, dz;
dx = x1 - px;
dy = y1 - py;
dz = z1 - pz;

var vx, vy, vz;
vx = x2 - x1;
vy = y2 - y1;
vz = z2 - z1;

var dp = (dx * nx + dy * ny + dz * nz);
var dn = (vx * nx + vy * ny + vz * nz);
if dn == 0
{
	return [x2, y2, z2, 0, 0, 0, false];
}

var t = - dp / dn; 
var s = sign(dp);
return [x1 + t * vx, y1 + t * vy, z1 + t * vz, s * nx, s * ny, s * nz, true];