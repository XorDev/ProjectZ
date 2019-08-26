/// @description smf_sphere_avoid_aa_cube(cubeX, cubeY, cubeZ, cubeSideLength, x, y, z, radius)
/// @param cubeX
/// @param cubeY
/// @param cubeZ
/// @param cubeSideLength
/// @param x
/// @param y
/// @param z
/// @param radius
/*
Makes the sphere (x, y, z) avoid the given axis-aligned cube.

Returns an array of the following format:
[x, y, z, xup, yup, zup, collision (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var bx, by, bz, S;
bx = argument0;
by = argument1;
bz = argument2;
S = argument3 / 2;

var dx, dy, dz, R, b;
dx = argument4 - bx;
dy = argument5 - by;
dz = argument6 - bz;
R = argument7;
b = max(abs(dx), abs(dy), abs(dz));

//Convert from world coordinates to block normalized coordinates
var cx, cy, cz, c;
cx = clamp(dx, -S, S);
cy = clamp(dy, -S, S);
cz = clamp(dz, -S, S);

var nx, ny, nz, d;
nx = 0;
ny = 0;
nz = 0;
if (b > S)
{
	d = sqr(cx - dx) + sqr(cy - dy) + sqr(cz - dz);
	if (d >= sqr(R)){
		return [argument4, argument5, argument6, 0, 0, 0, false];}
	d = 1 / sqrt(d);
	nx = (dx - cx) * d;
	ny = (dy - cy) * d;
	nz = (dz - cz) * d;
}
else if (b == abs(cx))
{
	nx = sign(cx);
	cx = S * nx;
}
else if (b == abs(cy))
{
	ny = sign(cy);
	cy = S * ny;
}
else// if (b == abs(cz))
{
	nz = sign(cz);
	cz = S * nz;
}

var px, py, pz;
px = bx + cx + nx * R;
py = by + cy + ny * R;
pz = bz + cz + nz * R;

//The sphere intersects with the block. Make the object sphere move out of the solid block
return [px, py, pz, nx, ny, nz, true];