/// @description smf_colmesh_read_from_buffer(buffer)
/// @param buffer
/*
Reads a collision mesh from the given buffer.
Returns the index of the new collision mesh
*/
var debugTime = current_time;

var loadBuff, tempBuff, buffSize;
loadBuff = argument0;

//Make sure this is a colmesh
var headerText = buffer_read(loadBuff, buffer_string);
if (headerText != "SMF Colmesh")
{
	show_debug_message("ERROR in script smf_colmesh_read_from_buffer: Could not find colmesh in buffer.");
	return -1;
}

buffSize = buffer_read(loadBuff, buffer_u32);
tempBuff = buffer_create(buffSize, buffer_fixed, 1);
buffer_copy(loadBuff, buffer_tell(loadBuff), buffSize, tempBuff, 0);

//Read header
var colMesh = ds_list_create();
colMesh[| eColMesh.TriangleList] = ds_list_create();
colMesh[| eColMesh.Type] = buffer_read(tempBuff, buffer_u8);
colMesh[| eColMesh.Depth] = buffer_read(tempBuff, buffer_u8);
colMesh[| eColMesh.BleedOver] = buffer_read(tempBuff, buffer_f32);
colMesh[| eColMesh.MinRegionSize] = buffer_read(tempBuff, buffer_f32);
var ox, oy, oz;
ox = buffer_read(tempBuff, buffer_f32);
oy = buffer_read(tempBuff, buffer_f32);
oz = buffer_read(tempBuff, buffer_f32);
colMesh[| eColMesh.Offset] = [ox, oy, oz];

//Read triangle list
var triList, triNum, tri, i, j;
triList = colMesh[| eColMesh.TriangleList];
triNum = buffer_read(tempBuff, buffer_u32);
for (i = 0; i < triNum; i ++)
{
	triList[| i] = array_create(12);
	tri = triList[| i];
	for (j = 0; j < 12; j ++)
	{
		tri[@ j] = buffer_read(tempBuff, buffer_f32);
	}
}

//Read subdivision lists using a custom recursion stack
var subdiv;
switch colMesh[| eColMesh.Type]
{
	case eColMeshSubdiv.None:
		colMesh[| eColMesh.Size] = buffer_read(tempBuff, buffer_f32);
		colMesh[| eColMesh.SubdivDS] = ds_list_create();
		subdiv = colMesh[| eColMesh.SubdivDS];
		for (var i = 0; i < triNum; i ++)
		{
			subdiv[| i] = i;
		}
		break;
		
	case eColMeshSubdiv.Lattice:
	var s, rSize, resx, resy, resz, xx, yy, zz, grid;
		s = array_create(0);
		s[0] = buffer_read(tempBuff, buffer_f32);
		s[1] = buffer_read(tempBuff, buffer_f32);
		s[2] = buffer_read(tempBuff, buffer_f32);
		colMesh[| eColMesh.Size] = s;
		colMesh[| eColMesh.SubdivDS] = ds_list_create();
		subdiv = colMesh[| eColMesh.SubdivDS];
		
		rSize = colMesh[| eColMesh.MinRegionSize];
		resx = ceil(s[0] / rSize);
		resy = ceil(s[1] / rSize);
		resz = ceil(s[2] / rSize);
		for (zz = 0; zz < resz; zz ++)
		{
			grid = ds_grid_create(resx, resy);
			subdiv[| zz] = grid;
			for (xx = 0; xx < resx; xx ++)
			{
				for (yy = 0; yy < resy; yy ++)
				{
					n = buffer_read(tempBuff, buffer_s32);
					if n >= 0
					{
						region = ds_list_create();
						grid[# xx, yy] = region;
						while n --
						{
							region[| n] = buffer_read(tempBuff, buffer_s32);
						}
					}
				}
			}
		}
		break;
		
	case eColMeshSubdiv.SpatialHash:
		var sx, sy, sz;
		sx = buffer_read(tempBuff, buffer_f32);
		sy = buffer_read(tempBuff, buffer_f32);
		sz = buffer_read(tempBuff, buffer_f32);
		colMesh[| eColMesh.Size] = [sx, sy, sz];
		var key, region, n, subdivN;
		subdivN = buffer_read(tempBuff, buffer_u32);
		colMesh[| eColMesh.SubdivDS] = ds_map_create();
		subdiv = colMesh[| eColMesh.SubdivDS];
		repeat subdivN
		{
			region = ds_list_create();
			key = string(buffer_read(tempBuff, buffer_u32));
			n = buffer_read(tempBuff, buffer_u32);
			while n --
			{
				region[| n] = buffer_read(tempBuff, buffer_s32);
			}
			subdiv[? key] = region;
		}
		break;
	
	case eColMeshSubdiv.Quadtree:
	case eColMeshSubdiv.Octree:
		var oct, gridW, gridH, u, v, probe;
		colMesh[| eColMesh.Size] = buffer_read(tempBuff, buffer_f32);
		oct = (colMesh[| eColMesh.Type] == eColMeshSubdiv.Octree);
		gridW = oct ? 8 : 4;
		gridH = buffer_read(tempBuff, buffer_u32);
		colMesh[| eColMesh.SubdivDS] = ds_grid_create(gridW, gridH);
		subdiv = colMesh[| eColMesh.SubdivDS];
		for (u = 0; u < gridW; u ++)
		{
			for (v = 0; v < gridH; v ++)
			{
				probe = buffer_read(tempBuff, buffer_s32);
				if probe <= 0
				{
					n = -probe;
					region = ds_list_create();
					subdiv[# u, v] = -region;
					while n --
					{
						region[| n] = buffer_read(tempBuff, buffer_s32);
					}
				}
				else
				{
					subdiv[# u, v] = probe;
				}
			}
		}
		break;
}

//Clean up and return result
show_debug_message("Script smf_colmesh_read_from_buffer: Read colmesh from buffer in " + string(current_time - debugTime) + " milliseconds");
buffer_delete(tempBuff);
return colMesh;
