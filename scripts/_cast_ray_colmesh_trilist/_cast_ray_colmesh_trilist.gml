/// @description smf__cast_ray_colmesh_trilist(regionList, triangleList, x1, y1, z1, lineDelta, returnNormal, skipBleed)
/// @param regionList
/// @param triangleList
/// @param x1
/// @param y1
/// @param z1
/// @param lineDelta
/// @param returnNormal
/// @param skipBleed
gml_pragma("forceinline");
var region, triList, triInd, x1, y1, z1, lDelta, retN, n, success, tri, t, ax, ay, az, bx, by, bz, itsX, itsY, itsZ, skipBleed, dp, i;
region = argument0;
triList = argument1;
x1 = argument2;
y1 = argument3;
z1 = argument4;
lDelta = argument5;
retN = argument6;
skipBleed = argument7;
success = false;
n = ds_list_size(region);
for (i = 0; i < n; i ++)
{   
	//Find intersection with triangle plane
	triInd = region[| i];
	if (skipBleed && triInd < 0){break;} //Break the loop if we encounter a negative index
	tri = triList[| abs(triInd)];
	t = tri[9] * lDelta[0] + tri[10] * lDelta[1] + tri[11] * lDelta[2];
	if (t == 0){continue;} //Continue if the ray is parallel to the surface of the triangle (ie. perpendicular to the triangle's normal)
	t = (tri[9] * (tri[0] - x1) + tri[10] * (tri[1] - y1) + tri[11] * (tri[2] - z1)) / t;
	if (t < 0 || t > 1){continue;} //Continue if the intersection is too far behind or in front of the ray
	itsX = x1 + lDelta[0] * t;
	itsY = y1 + lDelta[1] * t;
	itsZ = z1 + lDelta[2] * t;
	
	//Check first edge
	ax = itsX - tri[0]; 
	ay = itsY - tri[1]; 
	az = itsZ - tri[2];
	bx = tri[3] - tri[0]; 
	by = tri[4] - tri[1]; 
	bz = tri[5] - tri[2];
	dp = tri[9] * (az * by - ay * bz) + tri[10] * (ax * bz - az * bx) + tri[11] * (ay * bx - ax * by);
	if (dp < 0){continue;} //Continue if the intersection is outside this edge of the triangle
	if (dp == 0)
	{
		t = (ax * bx + ay * by + az * bz);
		if (t < 0 || t > sqr(bx) + sqr(by) + sqr(bz)){continue;} //Intersection is perfectly on this triangle edge. Continue if outside triangle.
	}
	
	//Check second edge
	ax = itsX - tri[3]; 
	ay = itsY - tri[4]; 
	az = itsZ - tri[5];
	bx = tri[6] - tri[3]; 
	by = tri[7] - tri[4]; 
	bz = tri[8] - tri[5];
	dp = tri[9] * (az * by - ay * bz) + tri[10] * (ax * bz - az * bx) + tri[11] * (ay * bx - ax * by);
	if (dp < 0){continue;} //Continue if the intersection is outside this edge of the triangle
	if (dp == 0)
	{
		t = (ax * bx + ay * by + az * bz);
		if (t < 0 || t > sqr(bx) + sqr(by) + sqr(bz)){continue;} //Intersection is perfectly on this triangle edge. Continue if outside triangle.
	}
	
	//Check third edge
	ax = itsX - tri[6]; 
	ay = itsY - tri[7]; 
	az = itsZ - tri[8];
	bx = tri[0] - tri[6]; 
	by = tri[1] - tri[7]; 
	bz = tri[2] - tri[8];
	dp = tri[9] * (az * by - ay * bz) + tri[10] * (ax * bz - az * bx) + tri[11] * (ay * bx - ax * by);
	if (dp < 0){continue;} //Continue if the intersection is outside this edge of the triangle
	if (dp == 0)
	{
		t = (ax * bx + ay * by + az * bz);
		if (t < 0 || t > sqr(bx) + sqr(by) + sqr(bz)){continue;} //Intersection is perfectly on this triangle edge. Continue if outside triangle.
	}
	
	//The line intersects the triangle. Save the triangle normal and intersection.
	retN[@ 0] = tri[9];
	retN[@ 1] = tri[10];
	retN[@ 2] = tri[11];
	lDelta[@ 0] = itsX - x1;
	lDelta[@ 1] = itsY - y1;
	lDelta[@ 2] = itsZ - z1;
	success = true;
}
return success;