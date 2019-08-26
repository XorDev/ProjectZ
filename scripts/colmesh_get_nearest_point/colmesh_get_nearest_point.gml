/// @description colmesh_get_nearest_point(colmesh, x, y, z)
/// @param colmesh
/// @param x
/// @param y
/// @param z
/*
	Returns the nearest point on the colmesh.
	Only works if there is any geometry in the currently active region

	Returns an array of the following format:
		[x, y, z, Nx, Ny, Nz, success]

	Script made by TheSnidr
	www.TheSnidr.com
*/
/////////////////////
//Load collision mesh
var colMesh, triList;
colMesh = argument0;
triList = colMesh[| eColMesh.TriangleList];

/////////////////////////
//Create collision sphere
var xx, yy, zz;
xx = argument1;
yy = argument2;
zz = argument3;

var minDist = 999999999;

var px, py, pz, nx, ny, nz;
px = xx;
py = yy;
pz = zz;
nx = 0;
ny = 0;
nz = 1;

var success = false;
var region = colmesh_get_region(colMesh, xx, yy, zz);

/////////////////////////////////////////////////////////////////////////////////////////////
if region > 0
{
	var i, j, tri, j1, j2, t0, t1, t2, u0, u1, u2, dp, dx, dy, dz, dist;
	for (i = ds_list_size(region) - 1; i >= 0; i --)
	{
		/////////////////////////////////////////////////////////////
		//Get the triangle info
		tri = triList[| abs(region[| i])];
	
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//Check each edge of the triangle. If the point is outside the edge, check the distance to the edge
		for (j = 0; j < 3; j ++)
		{
			j1 = 3 * j;
			j2 = (j1 + 3) mod 9;
			t0 = xx - tri[j1];
			t1 = yy - tri[j1+1];
			t2 = zz - tri[j1+2];
			u0 = tri[j2] - tri[j1];
			u1 = tri[j2+1] - tri[j1+1];
			u2 = tri[j2+2] - tri[j1+2];
			if ((t2 * u1 - t1 * u2) * tri[9] + (t0 * u2 - t2 * u0) * tri[10] + (t1 * u0 - t0 * u1) * tri[11] < 0)
			{
				dp = clamp((u0 * t0 + u1 * t1 + u2 * t2) / (sqr(u0) + sqr(u1) + sqr(u2)), 0, 1);
				dx = lerp(tri[j1],   tri[j2],   dp);
				dy = lerp(tri[j1+1], tri[j2+1], dp);
				dz = lerp(tri[j1+2], tri[j2+2], dp);
				dist = point_distance_3d(xx, yy, zz, dx, dy, dz);
				if (dist < minDist)
				{
					minDist = dist;
					px = dx;
					py = dy;
					pz = dz;
					nx = tri[9];
					ny = tri[10];
					nz = tri[11];
					success = true;
				}
				break;
			}
		}
		if j < 3{continue;}
	
		//////////////////////////////////////////////////////////////////////////////////////////
		//The point is directly above the triangle, and the nearest point can be found by projecting the point onto the plane defined by the triangle
		dist = ((xx - tri[0]) * tri[9] + (yy - tri[1]) * tri[10] + (zz - tri[2]) * tri[11]);
		if (abs(dist) < minDist)
		{
			minDist = abs(dist);
			px = xx - tri[9] * dist;
			py = yy - tri[10] * dist;
			pz = zz - tri[11] * dist;
			nx = tri[9];
			ny = tri[10];
			nz = tri[11];
			success = true;
		}
	}
}

//Return nearest point on the model
return [px, py, pz, nx, ny, nz, success];