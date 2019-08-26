/// @description smf_cast_ray_block(blockMatrix, x1, y1, z1, x2, y2, z2)
/// @param blockMatrix
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a block with the given matrix
The block matrix can be created with matrix_build(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale), where:
	(x, y, z) are the center coordinates of the cube,
	(xrot, yrot, zrot) are the euler angles of the cube, and
	(xscale, yscale, zscale) are half the side lengths of the cube (so the cube is actually twice as large as these values)

Returns the intersection as an array of the following format:
[x, y, z, nx, ny, nz, intersection (true or false)]

Script made by TheSnidr 2018
www.TheSnidr.com
*/
var bM;
bM = argument0;

var x1, y1, z1;
x1 = argument1 - bM[12];
y1 = argument2 - bM[13];
z1 = argument3 - bM[14];

var x2, y2, z2;
x2 = argument4 - bM[12];
y2 = argument5 - bM[13];
z2 = argument6 - bM[14];

//Convert from world coordinates to block normalized coordinates
var lx, ly, lz;
lx = 1 / (sqr(bM[0]) + sqr(bM[1]) + sqr(bM[2]));
ly = 1 / (sqr(bM[4]) + sqr(bM[5]) + sqr(bM[6]));
lz = 1 / (sqr(bM[8]) + sqr(bM[9]) + sqr(bM[10]));

var bx1, by1, bz1;
bx1 = (x1 * bM[0] + y1 * bM[1] + z1 * bM[2])  * lx;
by1 = (x1 * bM[4] + y1 * bM[5] + z1 * bM[6])  * ly;
bz1 = (x1 * bM[8] + y1 * bM[9] + z1 * bM[10]) * lz;

var bx2, by2, bz2;
bx2 = (x2 * bM[0] + y2 * bM[1] + z2 * bM[2])  * lx;
by2 = (x2 * bM[4] + y2 * bM[5] + z2 * bM[6])  * ly;
bz2 = (x2 * bM[8] + y2 * bM[9] + z2 * bM[10]) * lz;

var intersection, s, t, itsX, itsY, itsZ, d, nx, ny, nz;
intersection = false

//Check X dimension
if (bx2 != bx1)
{
	s = abs(bx1) < 1 ? sign(bx2 - bx1) : sign(bx1);
	t = (s - bx1) / (bx2 - bx1);
	if (t >= 0 && t <= 1)
	{
		itsY = lerp(by1, by2, t);
		itsZ = lerp(bz1, bz2, t);
		if (abs(itsY) <= 1 && abs(itsZ) <= 1)
		{
			bx2 = s;
			by2 = itsY;
			bz2 = itsZ;
			d = sqrt(lx);
			nx = bM[0] * d;
			ny = bM[1] * d;
			nz = bM[2] * d;
			intersection = true;
		}
	}
}

//Check Y dimension
if (by2 != by1)
{
	s = abs(by1) < 1 ? sign(by2 - by1) : sign(by1);
	t = (s - by1) / (by2 - by1);
	if (t >= 0 && t <= 1)
	{
		itsX = lerp(bx1, bx2, t);
		itsZ = lerp(bz1, bz2, t);
		if (abs(itsX) <= 1 && abs(itsZ) <= 1)
		{
			bx2 = itsX;
			by2 = s;
			bz2 = itsZ;
			d = sqrt(ly);
			nx = bM[4] * d;
			ny = bM[5] * d;
			nz = bM[6] * d;
			intersection = true;
		}
	}
}

//Check Z dimension
if (bz2 != bz1)
{
	s = abs(bz1) < 1 ? sign(bz2 - bz1) : sign(bz1);
	t = (s - bz1) / (bz2 - bz1);
	if (t >= 0 && t <= 1)
	{
		itsX = lerp(bx1, bx2, t);
		itsY = lerp(by1, by2, t);
		if (abs(itsX) <= 1 && abs(itsY) <= 1)
		{
			bx2 = itsX;
			by2 = itsY;
			bz2 = s;
			d = sqrt(lz);
			nx = bM[8] * d;
			ny = bM[9] * d;
			nz = bM[10] * d;
			intersection = true;
		}
	}
}

if (!intersection)
{
	return [argument4, argument5, argument6, 0, 0, 1, false];	
}

//Find the point of intersection in world space
var px, py, pz;
px = bM[12] + bx2 * bM[0] + by2 * bM[1] + bz2 * bM[2];
py = bM[13] + bx2 * bM[4] + by2 * bM[5] + bz2 * bM[6];
pz = bM[14] + bx2 * bM[8] + by2 * bM[9] + bz2 * bM[10];
return [px, py, pz, nx, ny, nz, true];