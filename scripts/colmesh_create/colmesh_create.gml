/// @description smf_colmesh_create(modelbuffer, bytesPerVert, type, minRegionSize, bleedOver, (maxDepth), (maxTrisPerRegion))
/// @param modelbuffer
/// @param bytesPerVert
/// @param type
/// @param minRegionSize
/// @param bleedOver
/// @param opt_maxDepth
/// @param opt_maxTrisPerRegion
/*
	Modelbuffer must be a regular buffer containing vertices. The script assumes that vertex positions are the first attributes of the vertex format.
	You need to supply the size of the format in bytes per vertex.

	This script subdivides a model so that fast collision checking can be performed later.
	Triangles that are outside a region, but not further away than bleedOver, are added to the region anyway.
	Type can be one of the following constants:
		eColMeshSubdiv.None (0)
		eColMeshSubdiv.Lattice (1)  <-- Note that minRegionSize will be the uniform region size for this structure!
		eColMeshSubdiv.SpatialHash (2)  <-- Note that minRegionSize will be the uniform region size for this structure!
		eColMeshSubdiv.Quadtree (3)
		eColMeshSubdiv.Octree (4)

	Script made by TheSnidr
	www.TheSnidr.com
*/
var debugTime = current_time;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Load arguments
var mBuff, bytesPerVert, type, minRegionSize, bleed, maxDepth, maxTrisPerRegion;
mBuff = argument[0];
bytesPerVert = argument[1];
type = argument[2];
minRegionSize = argument[3];
bleed = argument[4];
maxDepth = 10;
maxTrisPerRegion = 16;
if argument_count > 5
{	//Optional settings
	maxDepth = argument[5];
	if argument_count > 6
	{
		maxTrisPerRegion = argument[6];
	}
}

if is_array(mBuff){mBuff = mBuff[0];}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Initialize colmesh data structure
var colmesh, mBuff, i, j, k, bytesPerVert, triList;
colmesh = ds_list_create();
colmesh[| eColMesh.Depth] = 0;
colmesh[| eColMesh.Type] = type;
colmesh[| eColMesh.SubdivDS] = -1;
colmesh[| eColMesh.BleedOver] = bleed;
colmesh[| eColMesh.MinRegionSize] = minRegionSize;
colmesh[| eColMesh.TriangleList] = ds_list_create();

//Transformation
colmesh[| eColMesh.Scale] = 1;
colmesh[| eColMesh.Matrix] = -1;
colmesh[| eColMesh.InvMatrix] = -1;
colmesh[| eColMesh.DeltaMatrix] = -1;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Create triangle list from model buffer
var h, MIN, MAX, triNum, tri, mBuffSize, bytesPerTri, ux, uy, uz, vx, vy, vz, Nx, Ny, Nz, d, l;
h = 9999999;
MIN = [h, h, h];
MAX = [-h, -h, -h];
tri = array_create(9)
triList = ds_list_create();
bytesPerTri = bytesPerVert * 3;
mBuffSize = buffer_get_size(mBuff);
triNum = (mBuffSize div bytesPerVert) div 3;
for (i = 0; i < mBuffSize; i += bytesPerTri)
{
	for (j = 0; j < 3; j ++)
	{
		for (k = 0; k < 3; k ++)
		{
		    tri[j * 3 + k] = buffer_peek(mBuff, i + j * bytesPerVert + k * 4, buffer_f32);
			MIN[k] = min(MIN[k], tri[j * 3 + k]);
			MAX[k] = max(MAX[k], tri[j * 3 + k]);
		}
	}
	ux = tri[3] - tri[0];
	uy = tri[4] - tri[1];
	uz = tri[5] - tri[2];
	vx = tri[6] - tri[0];
	vy = tri[7] - tri[1];
	vz = tri[8] - tri[2];
	Nx = uy * vz - uz * vy;
	Ny = uz * vx - ux * vz;
	Nz = ux * vy - uy * vx;
	l = sqrt(sqr(Nx) + sqr(Ny) + sqr(Nz));
	if l == 0{continue;}
	d = 1 / l;
	ds_list_add(colmesh[| eColMesh.TriangleList], [tri[0], tri[1], tri[2], tri[3], tri[4], tri[5], tri[6], tri[7], tri[8], Nx * d, Ny * d, Nz * d]);
	ds_list_add(triList, ds_list_size(triList));
}
colmesh[| eColMesh.Offset] = [bleed - MIN[0], bleed - MIN[1], bleed - MIN[2]];
colmesh[| eColMesh.Size] = bleed * 2 + max(MAX[0] - MIN[0], MAX[1] - MIN[1], MAX[2] - MIN[2]);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Subdivide the model into the chosen structure
var regionNum, subdiv, rPos, rSize, prevTriList, leaf, key, o, triInd;
regionNum = 0;
o = colmesh[| eColMesh.Offset];
switch type
{
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//No subdivisions
	default:
		show_debug_message("Script smf_colmesh_create: Error when generating collision mesh: Type " + string(type) + " not supported. Creating ub-subdivided colmesh instead");
		colmesh[| eColMesh.Type] = eColMeshSubdiv.None;
	case eColMeshSubdiv.None:
		colmesh[| eColMesh.SubdivDS] = triList;
		show_debug_message("Script smf_colmesh_create: Generated collision mesh with no subdivisions in " + string(current_time - debugTime) + " milliseconds");
		break;
		
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Generate lattice or spatial hash
	case eColMeshSubdiv.Lattice:
	case eColMeshSubdiv.SpatialHash:
		var lat, rSize, hSize, subdiv, xx, yy, zz, s, resx, resy, resz, startX, startY, startZ, endX, endY, endZ, tri, i, _x, _y, _z, list, grid;
		lat = (type == eColMeshSubdiv.Lattice);
		rSize = minRegionSize;
		hSize = minRegionSize * .5;
		colmesh[| eColMesh.Size] = [bleed * 2 + MAX[0] - MIN[0], bleed * 2 + MAX[1] - MIN[1], bleed * 2 + MAX[2] - MIN[2]];
		s = colmesh[| eColMesh.Size];
		resx = ceil(s[0] / rSize);
		resy = ceil(s[1] / rSize);
		resz = ceil(s[2] / rSize);
		if (lat){
			subdiv = ds_list_create();
			for (zz = 0; zz < resz; zz ++){
				subdiv[| zz] = ds_grid_create(resx, resy);}}
		else{
			subdiv = ds_map_create();}
		colmesh[| eColMesh.Depth] = 1;
		colmesh[| eColMesh.SubdivDS] = subdiv;
		triNum = ds_list_size(triList);
		for (i = 0; i < triNum; i ++)
		{
			tri = ds_list_find_value(colmesh[| eColMesh.TriangleList], i);
			startX = max(0, floor((o[0] - bleed + min(tri[0], tri[3], tri[6])) / rSize));
			startY = max(0, floor((o[1] - bleed + min(tri[1], tri[4], tri[7])) / rSize));
			startZ = max(0, floor((o[2] - bleed + min(tri[2], tri[5], tri[8])) / rSize));
			endX = min(resx-1, ceil((o[0] + bleed + max(tri[0], tri[3], tri[6])) / rSize));
			endY = min(resy-1, ceil((o[1] + bleed + max(tri[1], tri[4], tri[7])) / rSize));
			endZ = min(resz-1, ceil((o[2] + bleed + max(tri[2], tri[5], tri[8])) / rSize));
			for (xx = startX; xx <= endX; xx ++)
			{
				_x = (xx + .5) * rSize - o[0];
				for (yy = startY; yy <= endY; yy ++)
				{
					_y = (yy + .5) * rSize - o[1];
					for (zz = startZ; zz <= endZ; zz ++)
					{
						_z = (zz + .5) * rSize - o[2];
						if (_tri_in_cube(tri, hSize + bleed, _x, _y, _z))
						{
							if (lat)
							{
								grid = subdiv[| zz];
								list = grid[# xx, yy];
								if (list == 0)
								{
									list = ds_list_create();
									grid[# xx, yy] = list;
									regionNum ++;
								}
							}
							else
							{
								key = xx + resx * yy + resx * resy * zz;
								list = subdiv[? string(key)];
								if (is_undefined(list))
								{
									list = ds_list_create();
									subdiv[? string(key)] = list;
									regionNum ++;
								}
							}
							if (_tri_in_cube(tri, hSize, _x, _y, _z))
							{	//The triangle is inside the main region. Insert it at the beginning of the list
								ds_list_insert(list, 0, i);
							}
							else
							{	//The triangle is outside the main region, but inside the bleedover region. Add it in negative
								ds_list_add(list, -i);
							}
						}
					}
				}
			}
		}
		show_debug_message("Script smf_colmesh_create: Generated " + (lat ? "lattice" : "spatial hash") +" with " + string(regionNum) + " regions in " + string(current_time - debugTime) + " milliseconds");
		break;
		
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Generate quadtree or octree
	case eColMeshSubdiv.Quadtree:
	case eColMeshSubdiv.Octree:
		//Parameters that are different between quadtrees and octrees
		var childNum, triIntersectScript, oct;
		oct = (type == eColMeshSubdiv.Octree);
		triIntersectScript = oct ? _tri_in_cube : _tri_in_square;
		childNum = oct ? 8 : 4;
		
		var stack, currU, currV, childV;
		stack = global.ColMeshStack;
		ds_stack_clear(stack);
		rPos = [-o[0], -o[1], -o[2]];
		rSize = colmesh[| eColMesh.Size] * .5;
		subdiv = ds_grid_create(childNum, 0);
		colmesh[| eColMesh.SubdivDS] = subdiv;
		currU = -1;
		currV = 0;
		while true
		{
			currU ++;
			prevTriList = triList;
			leaf = (ds_grid_height(subdiv) > 0 && (colmesh[| eColMesh.Depth] >= maxDepth || ds_list_size(triList) <= maxTrisPerRegion || rSize <= colmesh[| eColMesh.MinRegionSize]));
			if (leaf || currU >= childNum)
			{
				if (ds_stack_empty(stack))
				{   //If the stack is empty, the octree is done and we can break the loop
					show_debug_message("Script smf_colmesh_create: Generated " + (oct ? "octree" : "quadtree") + " with " + string(colmesh[| eColMesh.Depth]) + " levels and " + string(regionNum) + " regions in " + string(current_time - debugTime) + " milliseconds");
					break;
				}
				//Pop the parent region from stack, and write the child's index to the parent's regions
				rSize += rSize;
				childV = currV;
				currU = ds_stack_pop(stack);
				currV = ds_stack_pop(stack);
				triList = ds_stack_pop(stack);
				if (leaf)
				{   //If this is a leaf, make the triangle list reference negative to indicate this
					subdiv[# currU, currV] = -prevTriList;
					colmesh[| eColMesh.Depth] = max(colmesh[| eColMesh.Depth], log2(colmesh[| eColMesh.Size] / rSize));
				}
				else
				{
					subdiv[# currU, currV] = childV;
					ds_list_destroy(prevTriList);
				}
				rPos[0] -= rSize * (currU mod 2);
				rPos[1] -= rSize * ((currU div 2) mod 2);
				rPos[2] -= rSize * (currU div 4);
				continue;
			}
			//Push this region to stack, and add triangles that are in the new region to the new triangle list
			if (currU == 0)
			{
				currV = ds_grid_height(subdiv);
				ds_grid_resize(subdiv, childNum, currV + 1);
				regionNum += childNum;
			}
			ds_stack_push(stack, triList, currV, currU);
			rPos[0] += rSize * (currU mod 2);
			rPos[1] += rSize * ((currU div 2) mod 2);
			rPos[2] += rSize * (currU div 4);
			rSize *= .5;
			currU = -1;
			triList = ds_list_create();
			triNum = ds_list_size(prevTriList);
			for (i = 0; i < triNum; i ++)
			{
				triInd = abs(prevTriList[| i]);
				tri = ds_list_find_value(colmesh[| eColMesh.TriangleList], triInd);
				if script_execute(triIntersectScript, tri, rSize + bleed, rPos[0] + rSize, rPos[1] + rSize, rPos[2] + rSize)
				{
					if script_execute(triIntersectScript, tri, rSize, rPos[0] + rSize, rPos[1] + rSize, rPos[2] + rSize)
					{	//The triangle is inside the main region. Insert it at the beginning of the list
						ds_list_insert(triList, 0, triInd);
					}
					else 
					{	//The triangle is outside the main region, but inside the bleedover region. Add it in negative
						ds_list_add(triList, -triInd);
					}
				}
			}
		}
		break;
}
if colmesh[| eColMesh.Depth] != 0 && colmesh[| eColMesh.Depth] < maxDepth
{
	ds_list_destroy(triList);
}
return colmesh;