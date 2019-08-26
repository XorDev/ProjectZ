/// @description smf_colmesh_write_to_buffer(buffer, colmesh)
/// @param buffer
/// @param colmesh
/*
Writes the collision mesh to a previously created buffer.
Buffer needs to be a grow buffer (or an appropriately sized buffer) with an alignment of 1
*/
var debugTime = current_time;

var saveBuff, tempBuff, colMesh;
saveBuff = argument0;
colMesh = argument1;
tempBuff = buffer_create(1, buffer_grow, 1);

//Write header
buffer_write(tempBuff, buffer_u8, colMesh[| eColMesh.Type]);
buffer_write(tempBuff, buffer_u8, colMesh[| eColMesh.Depth]);
buffer_write(tempBuff, buffer_f32, colMesh[| eColMesh.BleedOver]);
buffer_write(tempBuff, buffer_f32, colMesh[| eColMesh.MinRegionSize]);
var o = colMesh[| eColMesh.Offset];
buffer_write(tempBuff, buffer_f32, o[0]);
buffer_write(tempBuff, buffer_f32, o[1]);
buffer_write(tempBuff, buffer_f32, o[2]);

//Write triangle list
var triList, triNum, tri, i, j;
triList = colMesh[| eColMesh.TriangleList];
triNum = ds_list_size(triList);
buffer_write(tempBuff, buffer_u32, triNum);
for (i = 0; i < triNum; i ++)
{
	tri = triList[| i];
	for (j = 0; j < 12; j ++)
	{
		buffer_write(tempBuff, buffer_f32, tri[j]);
	}
}

//Write subdivision lists using a custom recursion stack
var subdiv;
subdiv = colMesh[| eColMesh.SubdivDS];

//show_debug_message("Started writing colmesh to buffer");
switch colMesh[| eColMesh.Type]
{
	//////////////////////////////////////////////////////////////////////////////////////////
	//Write un-subdivided colmesh to buffer
	case eColMeshSubdiv.None:
		buffer_write(tempBuff, buffer_f32, colMesh[| eColMesh.Size]);
		break;
		
	//////////////////////////////////////////////////////////////////////////////////////////
	//Write lattice to buffer
	case eColMeshSubdiv.Lattice:
		var s, rSize, resx, resy, resz, xx, yy, zz, grid;
		s = colMesh[| eColMesh.Size];
		buffer_write(tempBuff, buffer_f32, s[0]);
		buffer_write(tempBuff, buffer_f32, s[1]);
		buffer_write(tempBuff, buffer_f32, s[2]);
		
		rSize = colMesh[| eColMesh.MinRegionSize];
		resx = ceil(s[0] / rSize);
		resy = ceil(s[1] / rSize);
		resz = ceil(s[2] / rSize);
		for (zz = 0; zz < resz; zz ++)
		{
			grid = subdiv[| zz];
			for (xx = 0; xx < resx; xx ++)
			{
				for (yy = 0; yy < resy; yy ++)
				{
					region = grid[# xx, yy];
					if region > 0
					{
						n = ds_list_size(region);
						buffer_write(tempBuff, buffer_s32, n);
						while n --
						{
							buffer_write(tempBuff, buffer_s32, region[| n]);
						}
					}
					else
					{
						buffer_write(tempBuff, buffer_s32, -1);
					}
				}
			}
		}
		break;
		
	//////////////////////////////////////////////////////////////////////////////////////////
	//Write spatial hash to buffer
	case eColMeshSubdiv.SpatialHash:
		var key, region, n, s;
		s = colMesh[| eColMesh.Size];
		buffer_write(tempBuff, buffer_f32, s[0]);
		buffer_write(tempBuff, buffer_f32, s[1]);
		buffer_write(tempBuff, buffer_f32, s[2]);
		buffer_write(tempBuff, buffer_u32, ds_map_size(subdiv));
		key = ds_map_find_first(subdiv);
		while !is_undefined(key)
		{
			region = subdiv[? key];
			n = ds_list_size(region);
			buffer_write(tempBuff, buffer_u32, real(key));
			buffer_write(tempBuff, buffer_u32, n);
			while n --
			{
				buffer_write(tempBuff, buffer_s32, region[| n]);
			}
			key = ds_map_find_next(subdiv, key);
		}
		break;
		
	//////////////////////////////////////////////////////////////////////////////////////////
	//Write quadtree or octree to buffer
	case eColMeshSubdiv.Quadtree:
	case eColMeshSubdiv.Octree:
		buffer_write(tempBuff, buffer_f32, colMesh[| eColMesh.Size]);
		
		var oct, gridW, gridH, u, v;
		oct = (colMesh[| eColMesh.Type] == eColMeshSubdiv.Octree);
		gridW = oct ? 8 : 4;
		gridH = ds_grid_height(subdiv);
		buffer_write(tempBuff, buffer_u32, gridH);
		for (u = 0; u < gridW; u ++)
		{
			for (v = 0; v < gridH; v ++)
			{
				region = subdiv[# u, v];
				if region <= 0
				{
					region = -region;
					n = ds_list_size(region);
					buffer_write(tempBuff, buffer_s32, -n);
					while n --
					{
						buffer_write(tempBuff, buffer_s32, region[| n]);
					}
				}
				else
				{
					buffer_write(tempBuff, buffer_s32, region);
				}
			}
		}
		break;
}

//Write to savebuff
var buffSize = buffer_tell(tempBuff);
buffer_write(saveBuff, buffer_string, "SMF Colmesh");
buffer_write(saveBuff, buffer_u32, buffSize);
buffer_copy(tempBuff, 0, buffSize, saveBuff, buffer_tell(saveBuff));
buffer_seek(saveBuff, buffer_seek_relative, buffSize);
show_debug_message("Script smf_colmesh_write_to_buffer: Wrote colmesh to buffer in " + string(current_time - debugTime) + " milliseconds");

//Clean up
buffer_delete(tempBuff);