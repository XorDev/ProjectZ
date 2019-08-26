/// @description smf_sphere_avoid_block(blockMatrix, x, y, z, radius)
/// @param blockMatrix[16]
/// @param x
/// @param y
/// @param z
/// @param radius
/*
Makes the sphere (x, y, z) avoid the given block.
The block matrix can be created with matrix_build(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale), where:
	(x, y, z) are the center coordinates of the cube,
	(xrot, yrot, zrot) are the euler angles of the cube, and
	(xscale, yscale, zscale) are half the side lengths of the cube (so the cube is actually twice as large as these values)

Returns an array of the following format:
[x, y, z, xup, yup, zup, collision (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var bM;
bM = argument0;

var dx, dy, dz, R
dx = argument1 - bM[12];
dy = argument2 - bM[13];
dz = argument3 - bM[14];
R = argument4;

//The inverse of the square of the scale of each dimension
var lx, ly, lz;
lx = 1 / (sqr(bM[0]) + sqr(bM[1]) + sqr(bM[2]));
ly = 1 / (sqr(bM[4]) + sqr(bM[5]) + sqr(bM[6]));
lz = 1 / (sqr(bM[8]) + sqr(bM[9]) + sqr(bM[10]));

//Find normalized block space position
var bx, by, bz, b;
bx = (dx * bM[0] + dy * bM[1] + dz * bM[2])  * lx;
by = (dx * bM[4] + dy * bM[5] + dz * bM[6])  * ly;
bz = (dx * bM[8] + dy * bM[9] + dz * bM[10]) * lz;
b = max(abs(bx), abs(by), abs(bz));

//Nearest point on the cube in normalized block space
var cx, cy, cz;
cx = clamp(bx, -1, 1);
cy = clamp(by, -1, 1);
cz = clamp(bz, -1, 1);

var d, nx, ny, nz, px, py, pz;
//If the center of the sphere is outside the cube, check if there is an intersection. If there is, move the sphere out of the cube
if (b > 1)
{
	px = cx * bM[0] + cy * bM[4] + cz * bM[8];
	py = cx * bM[1] + cy * bM[5] + cz * bM[9];
	pz = cx * bM[2] + cy * bM[6] + cz * bM[10];
	
	nx = dx - px;
	ny = dy - py;
	nz = dz - pz;
	d = sqr(nx) + sqr(ny) + sqr(nz);
	if d >= sqr(R){return [argument1, argument2, argument3, 0, 0, 0, false];}
	d = 1 / sqrt(d);
	nx *= d;
	ny *= d;
	nz *= d;
	
	px += bM[12] + nx * R;
	py += bM[13] + ny * R;
	pz += bM[14] + nz * R;
	return [px, py, pz, nx, ny, nz, true];
}

//If the center of the sphere is inside the cube, move it out at any cost
if (b == abs(cx))
{
	cx = sign(cx);
	d = cx * sqrt(lx);
	nx = bM[0] * d;
	ny = bM[1] * d;
	nz = bM[2] * d;
}
else if (b == abs(cy))
{
	cy = sign(cy);
	d = cy * sqrt(ly);
	nx = bM[4] * d;
	ny = bM[5] * d;
	nz = bM[6] * d;
}
else// if (b == abs(cz))
{
	cz = sign(cz);
	d = cz * sqrt(lz);
	nx = bM[8] * d;
	ny = bM[9] * d;
	nz = bM[10] * d;
}

px = cx * bM[0] + cy * bM[4] + cz * bM[8]  + bM[12] + nx * R;
py = cx * bM[1] + cy * bM[5] + cz * bM[9]  + bM[13] + ny * R;
pz = cx * bM[2] + cy * bM[6] + cz * bM[10] + bM[14] + nz * R;
return [px, py, pz, nx, ny, nz, true];