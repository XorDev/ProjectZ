/// @description smf_ellipsoid_avoid_colmesh_region(colmesh, region, x, y, z, radius, height, xup, yup, zup, slope(degrees))
/// @param colmesh
/// @param region
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param height
/// @param xup
/// @param yup
/// @param zup
/// @param slope(degrees)
/*
Pushes an ellipsoid at [x, y, z] with a given radius out of a collision mesh.
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
var success, newX, newY, newZ, xup, yup, zup, R, R2, H, rel, slope;
success = false;
newX = argument2;
newY = argument3;
newZ = argument4;
R = argument5;
H = argument6;
xup = argument7;
yup = argument8;
zup = argument9;
slopeAngle = argument10;

var savedUpvector, rnX, rnY, rnZ;
savedUpvector = false;
rnX = 0;
rnY = 0;
rnZ = 0;

var invM = colMesh[| eColMesh.InvMatrix];
if is_array(invM)
{
	var invScale = 1 / colMesh[| eColMesh.Scale];
	var P = matrix_transform_vertex(invM, newX, newY, newZ);
	newX = P[0];
	newY = P[1];
	newZ = P[2];
	
	var _xup = (invM[0] * xup + invM[4] * yup + invM[8] * zup) * invScale;
	var _yup = (invM[1] * xup + invM[5] * yup + invM[9] * zup) * invScale;
	var _zup = (invM[2] * xup + invM[6] * yup + invM[10] * zup) * invScale;
	xup = _xup;
	yup = _yup;
	zup = _zup;

	R *= invScale;
	H *= invScale;
}

//Since the sphere may move from the first pass to the second, it's a problem if geometry *just* outside the radius gets intersected after avoiding the geometry that was intersected in the first pass.
//This adjusts the radius of the sphere in the first pass to counteract this.
var firstPassR = 1.2 * R;
R2 = sqr(R);
rel = R / H;
newZ *= rel;

slope = dcos(argument10);
slope /= sqrt(sqr(slope) + (1 - sqr(slope)) * sqr(rel));

/////////////////////////////////////////////////////////////////////////////////////////////
//First pass, find which triangles are intersecting the player, and add them to a ds_priority
if region > 0
{
	var priority, i, j, tri, D, j1, j2, t0, t1, t2, u0, u1, u2, dp, d0, d1, d2, l, _r, _l, n;
	priority = global.ColMeshPriority;
	ds_priority_clear(priority);
	for (i = ds_list_size(region) - 1; i >= 0; i --)
	{
		/////////////////////////////////////////////////////////////
		//Transform the world geometry to give the collision response an illusion of an ellipsoid collision, while it is in fact a sphere collision
		tri = triList[| abs(region[| i])];
		tri[2] *= rel;
		tri[5] *= rel;
		tri[8] *= rel;
		tri[11] /= rel;
		n = 1 / max(sqrt(sqr(tri[9]) + sqr(tri[10]) + sqr(tri[11])), 0.00001);
		tri[9] *= n;
		tri[10] *= n;
		tri[11] *= n;
	
		/////////////////////////////////////////////////////////////
		//Check raw distance from sphere to plane defined by triangle
		D = ((newX - tri[0]) * tri[9] + (newY - tri[1]) * tri[10] + (newZ - tri[2]) * tri[11]);
		if (D == 0 || abs(D) >= firstPassR){continue;}
	
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
				l = sqr(u0 * dp - t0) + sqr(u1 * dp - t1) + sqr(u2 * dp - t2);
				if (l <= 0 || l >= R2){break;}
				ds_priority_add(priority, tri, l / R2);
				break;
			}
		}
		if j < 3{continue;}
	
		//////////////////////////////////////////////////////////////////////////////////////////
		//The sphere intersects the triangle, and the center of the sphere projects to the inside of the triangle
		ds_priority_add(priority, tri, sqr(D / R));
	}

	///////////////////////////////////////////////////////////////////////////////
	//Second pass, collide with the nearby triangles, starting with the closest one
	while !ds_priority_empty(priority)
	{
		/////////////////////////////////////////////////////////////
		//Check raw distance from sphere to plane defined by triangle
		tri = ds_priority_delete_min(priority);
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
			
				if !savedUpvector
				{
					rnX = d0;
					rnY = d1;
					rnZ = d2;
					savedUpvector = true;
				}
				_r = R - 1 / l;
				dp = d0 * xup + d1 * yup + d2 * zup;
				if dp > slope
				{
					_r /= dp;
					newX += xup * _r;
					newY += yup * _r;
					newZ += zup * _r;
				}
				else
				{
					newX += d0 * _r;
					newY += d1 * _r;
					newZ += d2 * _r;
				}
			    success = true;
				break;
			}
		}
		if j < 3{continue;}
	
		//////////////////////////////////////////////////////////////////////////////////////////
		//The sphere intersects the triangle, and the center of the sphere projects to the inside of the triangle
		if !savedUpvector
		{
			rnX = tri[9];
			rnY = tri[10];
			rnZ = tri[11];
			savedUpvector = true;
		}
		dp = tri[9] * xup + tri[10] * yup + tri[11] * zup;
		_r = sign(D) * (R - abs(D));
		if dp > slope
		{
			_r /= dp;
			newX += xup * _r;
			newY += yup * _r;
			newZ += zup * _r;
		}
		else
		{
			newX += tri[9] * _r;
			newY += tri[10] * _r;
			newZ += tri[11] * _r;
		}
		success = true;
	}
}
newZ /= rel;

var M = colMesh[| eColMesh.Matrix];
if is_array(M)
{
	var scale = colMesh[| eColMesh.Scale];
	var P = matrix_transform_vertex(M, newX, newY, newZ);
	newX = P[0];
	newY = P[1];
	newZ = P[2];
	
	xup = (M[0] * xup + M[4] * yup + M[8] * zup) * scale;
	yup = (M[1] * xup + M[5] * yup + M[9] * zup) * scale;
	zup = (M[2] * xup + M[6] * yup + M[10] * zup) * scale;
}

//Transform player coordinates back into world space
return [newX, newY, newZ, xup, yup, zup, success];