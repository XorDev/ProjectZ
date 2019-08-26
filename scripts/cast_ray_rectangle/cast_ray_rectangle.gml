/// @description cast_ray_rectangle(rectX, rectY, rectWidth, rectHeight, x1, y1, x2, y2)
/// @param blockX
/// @param blockY
/// @param blockWidth
/// @param blockHeight
/// @param x1
/// @param y1
/// @param x2
/// @param y2
/*
	Finds the intersection between a line segment going from [x1, y1] to [x2, y2], and a rectangle
	Returns the intersection as an array of the following format:
		[x, y]

	Script made by TheSnidr 2019
	www.TheSnidr.com
*/
var bX, bY, bW, bH;
bX = argument0;
bY = argument1;
bW = argument2;
bH = argument3;

//Convert from world coordinates to rectangle normalized coordinates
var bx1, by1;
bx1 = (argument4 - bX) * 2 / bW;
by1 = (argument5 - bY) * 2 / bH;

var bx2, by2;
bx2 = (argument6 - bX) * 2 / bW;
by2 = (argument7 - bY) * 2 / bH;

var s, t, itsX, itsY;

//Check X dimension
if (bx2 != bx1)
{
	s = abs(bx1) < 1 ? sign(bx2 - bx1) : sign(bx1);
	t = (s - bx1) / (bx2 - bx1);
	if (t >= 0 && t <= 1)
	{
		itsY = lerp(by1, by2, t);
		if (abs(itsY) <= 1)
		{
			bx2 = s;
			by2 = itsY;
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
		if (abs(itsX) <= 1)
		{
			bx2 = itsX;
			by2 = s;
		}
	}
}

//Find the point of intersection in world space
return [bX + bx2 * bW / 2, bY + by2 * bH / 2];