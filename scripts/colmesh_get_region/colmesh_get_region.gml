/// @description colmesh_get_region(colMesh, x, y, z)
/// @param colMesh
/// @param x
/// @param y
/// @param z
/*
	Returns a ds_list containing the indices of all triangles in this region

	Script made by TheSnidr
	www.TheSnidr.com
*/
var colMesh, offset, posX, posY, posZ, subdiv, region, size, key, rSize, invM;
colMesh = argument0;
subdiv = colMesh[| eColMesh.SubdivDS];
size = colMesh[| eColMesh.Size];
offset = colMesh[| eColMesh.Offset];
posX = argument1;
posY = argument2;
posZ = argument3;
invM = colMesh[| eColMesh.InvMatrix];
if is_array(invM)
{
	var P = matrix_transform_vertex(invM, posX, posY, posZ);
	posX = P[0];
	posY = P[1];
	posZ = P[2];
}
posX += offset[0];
posY += offset[1];
posZ += offset[2];
switch colMesh[| eColMesh.Type]
{
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//If the model has not been subdivided, simply return the list containing all the triangles of the model
	case eColMeshSubdiv.None:
		return subdiv;
		
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Get the current region in a lattice or a spatial hash
	case eColMeshSubdiv.Lattice:
	case eColMeshSubdiv.SpatialHash:
		var resx, resy, resz;
		rSize = colMesh[| eColMesh.MinRegionSize];
		resx = ceil(size[0] / rSize);
		resy = ceil(size[1] / rSize);
		resz = ceil(size[2] / rSize);
		posX = clamp(floor(posX / rSize), 0, resx - 1);
		posY = clamp(floor(posY / rSize), 0, resy - 1);
		posZ = clamp(floor(posZ / rSize), 0, resz - 1);
		if colMesh[| eColMesh.Type] == eColMeshSubdiv.Lattice
		{
			var grid = subdiv[| posZ];
			return grid[# posX, posY];
		}
		key = posX + resx * posY + resx * resy * posZ;
		region = subdiv[? string(key)];
		return is_undefined(region) ? 0 : region;
		
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Get the nearest region of a quadtree
	case eColMeshSubdiv.Quadtree:
		var currU, currV;
		currV = 0;
		while currV >= 0
		{
			size *= .5;
			currU = 0;
			if (posX >= size){posX -= size; currU += 1;}
			if (posY >= size){posY -= size; currU += 2;}
			currV = subdiv[# currU, currV];
		}
		region = -currV;
		return region;
		
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Get the nearest region of an octree
	case eColMeshSubdiv.Octree:
		var currU, currV;
		currV = 0;
		while currV >= 0
		{
			size *= .5;
			currU = 0;
			if (posX >= size){posX -= size; currU += 1;}
			if (posY >= size){posY -= size; currU += 2;}
			if (posZ >= size){posZ -= size; currU += 4;}
			currV = subdiv[# currU, currV];
		}
		region = -currV;
		return region;
}