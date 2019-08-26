/// @description smf_cast_ray_aa_cube(cubeX, cubeY, cubeZ, cubeSideLength, x1, y1, z1, x2, y2, z2)
/// @param cubeX
/// @param cubeY
/// @param cubeZ
/// @param cubeSideLength
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a given axis-aligned cube

Returns the intersection as an array of the following format:
[x, y, z, nx, ny, nz, intersection (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var bx, by, bz, S;
bx = argument0;
by = argument1;
bz = argument2;
S = argument3 / 2;

var x1, y1, z1;
x1 = argument4 - bx;
y1 = argument5 - by;
z1 = argument6 - bz;

var x2, y2, z2;
x2 = argument7 - bx;
y2 = argument8 - by;
z2 = argument9 - bz;

var intersection, nx, ny, nz, s, t, itsX, itsY, itsZ;
intersection = false;

//Check Z dimension
if (x1 != x2)
{
	s = sign(x1);
	t = (s * S - x1) / (x2 - x1);
	if ((t > 0) && (t < 1))
	{
		itsY = lerp(y1, y2, t);
		itsZ = lerp(z1, z2, t);
		if ((abs(itsY) < S) && (abs(itsZ) < S))
		{
			x2 = s * S;
			y2 = itsY;
			z2 = itsZ;
			nx = s;
			intersection = true;
		}
	}
}

//Check Y dimension
if (y1 != y2)
{
	s = sign(y1);
	t = (s * S - y1) / (y2 - y1);
	if ((t > 0) && (t < 1))
	{
		itsX = lerp(x1, x2, t);
		itsZ = lerp(z1, z2, t);
		if ((abs(itsX) < S) && (abs(itsZ) < S))
		{
			x2 = itsX;
			y2 = s * S;
			z2 = itsZ;
			nx = 0;
			ny = s;
			intersection = true;
		}
	}
}

//Check Z dimension
if (z1 != z2)
{
	s = sign(z1);
	t = (s * S - z1) / (z2 - z1);
	if ((t > 0) && (t < 1))
	{
		itsX = lerp(x1, x2, t);
		itsY = lerp(y1, y2, t);
		if ((abs(itsX) < S) && (abs(itsY) < S))
		{
			x2 = itsX;
			y2 = itsY;
			z2 = s * S;
			nx = 0;
			ny = 0;
			nz = s;
			intersection = true;
		}
	}
}

if (!intersection)
{
	return [argument7, argument8, argument9, 0, 0, 0, false];
}

var px, py, pz;
px = bx + x2;
py = by + y2;
pz = bz + z2;

return [px, py, pz, nx, ny, nz, true];