/// @description smf_cast_ray_colmesh(colmesh, x1, y1, z1, x2, y2, z2)
/// @param colmesh
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
Flawless ray casting, but is slow.

Casts a ray from one point to another and returns the position of the first collision with geometry
Returns an array with the following format:
[x, y, z, normalX, normalY, normalZ, success]

Script made by TheSnidr
www.TheSnidr.com
*/
var colMesh, lStart, xEnd, yEnd, zEnd, transformed;
colMesh = argument0;
lStart = [argument1, argument2, argument3];
xEnd = argument4;
yEnd = argument5;
zEnd = argument6;

transformed = is_array(colMesh[| eColMesh.Matrix]);
if transformed
{
	//The colmesh has been transformed. Instead of actually transforming the colmesh, however, we can transform the ray by the inverse of the matrix
	lStart = matrix_transform_vertex(colMesh[| eColMesh.InvMatrix], lStart[0], lStart[1], lStart[2]);
	var P = matrix_transform_vertex(colMesh[| eColMesh.InvMatrix], xEnd, yEnd, zEnd);
	xEnd = P[0];
	yEnd = P[1];
	zEnd = P[2];
}

var retN, success, rPos, lDelta;
retN = [0, 0, 0];
success = false;
lDelta = [xEnd - lStart[0], yEnd - lStart[1], zEnd - lStart[2]];

var triList, subdiv, offset;
triList = colMesh[| eColMesh.TriangleList];
subdiv = colMesh[| eColMesh.SubdivDS];
offset = colMesh[| eColMesh.Offset];

switch colMesh[| eColMesh.Type]
{
	//////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////
	//Cast ray onto un-subdivided colmesh
	case eColMeshSubdiv.None:
		success = _cast_ray_colmesh_trilist(subdiv, triList, lStart[0], lStart[1], lStart[2], lDelta, retN, true);
		break;
		
	//////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////
	//Cast ray onto lattice or spatial hash
	case eColMeshSubdiv.Lattice:
	case eColMeshSubdiv.SpatialHash:
		var rSize, iSize, s;
		rSize = colMesh[| eColMesh.MinRegionSize];
		iSize = 1 / rSize;
		s = colMesh[| eColMesh.Size];
		
		var resx, resy, resz;
		resx = ceil(s[0] / rSize);
		resy = ceil(s[1] / rSize);
		resz = ceil(s[2] / rSize);
		
		var ldx, ldy, ldz;
		ldx = lDelta[0];
		ldy = lDelta[1];
		ldz = lDelta[2];
		lDelta[0] = 0;
		lDelta[1] = 0;
		lDelta[2] = 0;
		
		var idx, idy, idz, incx, incy, incz, add;
		idx = sign(ldx) / max(abs(ldx), 0.00001);
		idy = sign(ldy) / max(abs(ldy), 0.00001);
		idz = sign(ldz) / max(abs(ldz), 0.00001);
		incx = rSize * abs(idx);
		incy = rSize * abs(idy);
		incz = rSize * abs(idz);
		add = - floor(min(lStart[0], xEnd, lStart[1], yEnd, lStart[2], zEnd) / rSize) * rSize;
		
		var dx, dy, dz, t, m;
		dx = 1;
		dy = 1;
		dz = 1;
		t = 0;
		m = 0;
		
		var currX, currY, currZ, rx, ry, rz, region, key, grid;
		while (t < 1)
		{
			//Find new current ray position
			currX = offset[0] + lStart[0] + lDelta[0];
			currY = offset[1] + lStart[1] + lDelta[1];
			currZ = offset[2] + lStart[2] + lDelta[2];
			
			//Modify the position and find the lattice position of the ray
			rx = floor(currX * iSize);
			ry = floor(currY * iSize);
			rz = floor(currZ * iSize);
			if (m > 0){
				if (m == dx){
					currX = round(currX * iSize) * rSize;
					rx = floor(currX * iSize) - (ldx < 0);}
				else if (m == dy){
					currY = round(currY * iSize) * rSize;
					ry = floor(currY * iSize) - (ldy < 0);}
				else{
					currZ = round(currZ * iSize) * rSize;
					rz = floor(currZ * iSize) - (ldz < 0);}}
				
			//Find which region needs to travel the shortest to cross a wall
			if (ldx != 0){
				dx = - ((currX + add) mod rSize) * idx;
				if (dx <= 0){
					dx += incx;}}
			if (ldy != 0){
				dy = - ((currY + add) mod rSize) * idy;
				if (dy <= 0){
					dy += incy;}}
			if (ldz != 0){
				dz = - ((currZ + add) mod rSize) * idz;
				if (dz <= 0){
					dz += incz;}}
			
			//Find the new end position of the ray
			m = min(dx, dy, dz);
			t += m;
			lDelta[0] = ldx * t;
			lDelta[1] = ldy * t;
			lDelta[2] = ldz * t;
			
			//Continue the loop if the ray is outside the region
			if (rx < 0 || rx >= resx || ry < 0 || ry >= resy || rz < 0 || rz >= resz){continue;}
			
			//Find the current region of the ray
			if (colMesh[| eColMesh.Type] == eColMeshSubdiv.Lattice)
			{
				grid = subdiv[| rz];
				region = grid[# rx, ry];
				if (region <= 0){continue;} //If the region does not exist, continue the loop
			}
			else
			{
				key = rx + ry * resx + rz * resx * resy;
				region = subdiv[? string(key)];
				if (is_undefined(region)){continue;} //If the region does not exist, continue the loop
			}
			if (_cast_ray_colmesh_trilist(region, triList, lStart[0], lStart[1], lStart[2], lDelta, retN, true))
			{	//Since rays through spatial hashes always go from the nearest to the farthest regions, we can exit as soon as we find an intersection
				success = true;
				break;
			}
		}
		break;

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////
	//Cast ray onto quadtree
	case eColMeshSubdiv.Quadtree:
		var rSize, hSize, rPos, its, stack, progress, currU, currV, subdivRegion, i, j;
		rSize = colMesh[| eColMesh.Size];
		subdivRegion = array_create(2);
		rPos = [-offset[0], -offset[1]];
		its = array_create(2);
		stack = global.ColMeshStack;
		ds_stack_clear(stack);
		progress = -1;
		currU = 0;
		currV = 0;
		while true
		{
			if (currV >= 0)
			{   //Iterate through the octree
				hSize = rSize / 2;
				if progress < 0
				{	//If progress is less than 0, it means that we have just encountered this region. Thus we need to first check either the starting region of the ray, or the first region it intersects
					for (i = 0; i < 2; i ++) //For each dimension
					{
						subdivRegion[i] = (lStart[i] == rPos[i] + hSize) ? (lDelta[i] >= 0) : (lStart[i] > rPos[i] + hSize);
						if (lDelta[i] == 0){continue;} //If the ray has length of 0 in this dimension, do not check for intersections
						if (lStart[i] >= rPos[i] && lStart[i] <= rPos[i] + rSize){continue;} //If the starting position is inside the current region, do not check for intersections
						t = (rPos[i] + subdivRegion[i] * rSize - lStart[i]) / lDelta[i];
						if (t < 0 || t > 1){continue;}
						j = !i; 
						its[j] = lStart[j] + lDelta[j] * t - rPos[j];
						if (its[j] < 0 || its[j] > rSize){continue;}
						subdivRegion[j] = (its[j] == hSize) ? (lDelta[j] >= 0) : (its[j] > hSize);
						break;
					}
				}
				else
				{	//If progress is 0 or more, we've already tested the first region, and we need to test for intersections with the three planes that divide the region into child regions.
					for (i = progress; i < 2; i ++)
					{	//Check for intersections with the middle plane of each dimension
						if (lDelta[i] == 0){continue;}
						t = (rPos[i] + hSize - lStart[i]) / lDelta[i];
						if (t < 0 || t > 1){continue;}
						j = !i;
						its[j] = lStart[j] + lDelta[j] * t - rPos[j];
						if (its[j] < 0 || its[j] > rSize){continue;}
						subdivRegion[i] = (lStart[i] == rPos[i] + hSize) ? (lDelta[i] <= 0) : (lStart[i] < rPos[i] + hSize);
						subdivRegion[j] = (lStart[j] == rPos[j] + hSize) ? (lDelta[j] >= 0) : (its[j] > hSize);
						break;
					}
					progress = i;
				}
				if (progress < 2)
				{
					currU = subdivRegion[0] | (subdivRegion[1] << 1);
					ds_stack_push(stack, progress, currV, currU);
					rSize *= .5;
					rPos[0] += rSize * subdivRegion[0];
					rPos[1] += rSize * subdivRegion[1];
					currV = subdiv[# currU, currV];
					progress = -1;
					continue;
				}
			}
			else
			{	//If this is a leaf region, check for intersections with the triangles in this leaf
				region = -currV;
				success = _cast_ray_colmesh_trilist(region, triList, lStart[0], lStart[1], lStart[2], lDelta, retN, true);
			}
			if (ds_stack_size(stack) == 0)
			{	//If the stack is empty, the loop is done
				break;
			}
			//Pop the previous region from stack
			currU = ds_stack_pop(stack);
			currV = ds_stack_pop(stack);
			progress = ds_stack_pop(stack) + 1;
			rPos[0] -= rSize * (currU mod 2);
			rPos[1] -= rSize * ((currU div 2) mod 2);
			rSize += rSize;
		}
		break;
		
	//////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////
	//Cast ray onto octree
	case eColMeshSubdiv.Octree:
		var rSize, hSize, rPos, its, stack, progress, currU, currV, subdivRegion, i, j, k;
		rSize = colMesh[| eColMesh.Size];
		rPos = [-offset[0], -offset[1], -offset[2]];
		its = array_create(3);
		stack = global.ColMeshStack;
		ds_stack_clear(stack);
		progress = -1;
		currU = 0;
		currV = 0;
		
		
		while true
		{
			if (currV >= 0)
			{   //Iterate through the octree
				hSize = rSize / 2;
				if progress < 0
				{	//If progress is less than 0, it means that we have just encountered this region. Thus we need to first check either the starting region of the ray, or the first region it intersects
					for (i = 0; i < 3; i ++) //For each dimension
					{
						subdivRegion[i] = (lStart[i] == rPos[i] + hSize) ? (lDelta[i] >= 0) : (lStart[i] > rPos[i] + hSize);
						if (lDelta[i] == 0){continue;} //If the ray has length of 0 in this dimension, do not check for intersections
						if (lStart[i] >= rPos[i] && lStart[i] <= rPos[i] + rSize){continue;} //If the starting position is inside the current region, do not check for intersections
						t = (rPos[i] + subdivRegion[i] * rSize - lStart[i]) / lDelta[i];
						if (t < 0 || t > 1){continue;}
						j = (i + 1) mod 3; 
						k = (i + 2) mod 3;
						its[j] = lStart[j] + lDelta[j] * t - rPos[j];
						its[k] = lStart[k] + lDelta[k] * t - rPos[k];
						if (its[j] < 0 || its[j] > rSize || its[k] < 0 || its[k] > rSize){continue;}
						subdivRegion[j] = (its[j] == hSize) ? (lDelta[j] >= 0) : (its[j] > hSize);
						subdivRegion[k] = (its[k] == hSize) ? (lDelta[k] >= 0) : (its[k] > hSize);
						break;
					}
				}
				else
				{	//If progress is 0 or more, we've already tested the first region, and we need to test for intersections with the three planes that divide the region into child regions.
					for (i = progress; i < 3; i ++)
					{	//Check for intersections with the middle plane of each dimension
						if (lDelta[i] == 0){continue;}
						t = (rPos[i] + hSize - lStart[i]) / lDelta[i];
						if (t < 0 || t > 1){continue;}
						j = (i + 1) mod 3; 
						k = (i + 2) mod 3;
						its[j] = lStart[j] + lDelta[j] * t - rPos[j];
						its[k] = lStart[k] + lDelta[k] * t - rPos[k];
						if (its[j] < 0 || its[j] > rSize || its[k] < 0 || its[k] > rSize){continue;}
						subdivRegion[i] = (lStart[i] == rPos[i] + hSize) ? (lDelta[i] <= 0) : (lStart[i] < rPos[i] + hSize);
						subdivRegion[j] = (lStart[j] == rPos[j] + hSize) ? (lDelta[j] >= 0) : (its[j] > hSize);
						subdivRegion[k] = (lStart[k] == rPos[k] + hSize) ? (lDelta[k] >= 0) : (its[k] > hSize);
						break;
					}
					progress = i;
				}
				if (progress < 3)
				{
					currU = subdivRegion[0] | (subdivRegion[1] << 1) | (subdivRegion[2] << 2);
					ds_stack_push(stack, progress, currV, currU);
					rSize *= .5;
					rPos[0] += rSize * subdivRegion[0];
					rPos[1] += rSize * subdivRegion[1];
					rPos[2] += rSize * subdivRegion[2];
					currV = subdiv[# currU, currV];
					progress = -1;
					continue;
				}
			}
			else
			{	//If this is a leaf region, check for intersections with the triangles in this leaf
				region = -currV;
				success = _cast_ray_colmesh_trilist(region, triList, lStart[0], lStart[1], lStart[2], lDelta, retN, true);
			}
			if (ds_stack_size(stack) == 0)
			{	//If the stack is empty, break the loop
				break;
			}
			//Pop the previous region from stack
			currU = ds_stack_pop(stack);
			currV = ds_stack_pop(stack);
			progress = ds_stack_pop(stack) + 1;
			rPos[0] -= rSize * (currU mod 2);
			rPos[1] -= rSize * ((currU div 2) mod 2);
			rPos[2] -= rSize * (currU div 4);
			rSize += rSize;
		}
		break;
}

xEnd = lStart[0] + lDelta[0];
yEnd = lStart[1] + lDelta[1];
zEnd = lStart[2] + lDelta[2];
if transformed
{
	//After performing ray casting, we must transform the end position of the ray back into world space
	var P = matrix_transform_vertex(colMesh[| eColMesh.Matrix], xEnd, yEnd, zEnd);
	xEnd = P[0];
	yEnd = P[1];
	zEnd = P[2];
}

return [xEnd, yEnd, zEnd, retN[0], retN[1], retN[2], success];