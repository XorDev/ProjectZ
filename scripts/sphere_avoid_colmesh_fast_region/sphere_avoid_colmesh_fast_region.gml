/// @description smf_sphere_avoid_colmesh_fast_region(colmesh, region, x, y, z, radius)
/// @param colmesh
/// @param region
/// @param x
/// @param y
/// @param z
/// @param radius
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
/////////////////////
//Load collision mesh
var colMesh, region, triList;
colMesh = argument0;
region = argument1;
triList = colMesh[| eColMesh.TriangleList];

/////////////////////////
//Create collision sphere
var success, newX, newY, newZ, R, R2;
success = false;
newX = argument2;
newY = argument3;
newZ = argument4;
R = argument5;
R2 = sqr(R);

var rnX, rnY, rnZ;
rnX = 0
rnY = 0;
rnZ = -1;

//Since the sphere may move from the first pass to the second, it's a problem if geometry *just* outside the radius gets intersected after avoiding the geometry that was intersected in the first pass.
//This adjusts the radius of the sphere in the first pass to counteract this.

/////////////////////////////////////////////////////////////////////////////////////////////
//First pass, find which triangles are intersecting the player, and add them to a ds_priority
if region > 0
{
	var i, j, tri, D, j1, j2, t0, t1, t2, u0, u1, u2, dp, d0, d1, d2, l, _r;
	for (i = ds_list_size(region) - 1; i >= 0; i --)
	{
		/////////////////////////////////////////////////////////////
		//Check raw distance from sphere to plane defined by triangle
		tri = triList[| abs(region[| i])];
		D = ((newX - tri[0]) * tri[9] + (newY - tri[1]) * tri[10] + (newZ - tri[2]) * tri[11]);
		if (D == 0 || abs(D) >= R){continue;}
	
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Check each edge of the triangle. If the player is outside the edge, check the distance to the edge
		for (j = 0; j < 3; j ++)
		{
			j1 = 3 * j;
			j2 = (j1 + 3) mod 9;
			t0 = newX - tri[j1];
			t1 = newY - tri[j1+1];
			t2 = newZ - tri[j1+2];
			u0 = tri[j2] - tri[j1];
			u1 = tri[j2+1] - tri[j1+1];
			u2 = tri[j2+2] - tri[j1+2];
			if ((t2 * u1 - t1 * u2) * tri[9] + (t0 * u2 - t2 * u0) * tri[10] + (t1 * u0 - t0 * u1) * tri[11] < 0)
			{
				dp = clamp((u0 * t0 + u1 * t1 + u2 * t2) / (sqr(u0) + sqr(u1) + sqr(u2)), 0, 1);
				d0 = t0 - u0 * dp;
				d1 = t1 - u1 * dp;
				d2 = t2 - u2 * dp;
				l = sqr(d0) + sqr(d1) + sqr(d2);
				if (l == 0 || l >= R2){break;}
				
				l = 1 / sqrt(l);
				d0 *= l;
				d1 *= l;
				d2 *= l;
			
				if d2 > rnZ
				{
					rnX = d0;
					rnY = d1;
					rnZ = d2;
				}
				_r = R - 1 / l;
				newX += d0 * _r;
				newY += d1 * _r;
				newZ += d2 * _r;
			    success = true;
				break;
			}
		}
		if j < 3{continue;}
	
		//////////////////////////////////////////////////////////////////////////////////////////
		//The sphere intersects the triangle, and the center of the sphere projects to the inside of the triangle
		_r = sign(D) * (R - abs(D));
		newX += tri[9] * _r;
		newY += tri[10] * _r;
		newZ += tri[11] * _r;
		success = true;
		if tri[11] > rnZ
		{
			rnX = tri[9];
			rnY = tri[10];
			rnZ = tri[11];
		}
	}
}
//Transform player coordinates back into world space
return [newX, newY, newZ, rnX, rnY, rnZ, success];