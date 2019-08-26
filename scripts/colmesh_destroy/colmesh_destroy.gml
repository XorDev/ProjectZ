/// @description smf_colmesh_destroy(colMesh)
/// @param colMesh
/*
Destroys a previously created colmesh

Script made by TheSnidr
www.TheSnidr.com
*/
var colMesh, subdiv;
colMesh = argument0;
ds_list_destroy(colMesh[| eColMesh.TriangleList]);

subdiv = colMesh[| eColMesh.SubdivDS];
switch colMesh[| eColMesh.Type]
{
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Generate lattice or spatial hash
	case eColMeshSubdiv.Lattice:
		var s, rSize, resx, resy, resz, xx, yy, zz, grid;
		s = colMesh[| eColMesh.Size];
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
					if grid[# xx, yy] >= 0
					{
						ds_list_destroy(grid[# xx, yy]);
					}
				}
			}
			ds_grid_destroy(grid);
		}
		ds_list_destroy(subdiv);
		break;
		
	case eColMeshSubdiv.SpatialHash:
		var s, rSize, resx, resy, resz, xx, yy, zz, grid, region;
		s = colMesh[| eColMesh.Size];
		rSize = colMesh[| eColMesh.MinRegionSize];
		resx = ceil(s[0] / rSize);
		resy = ceil(s[1] / rSize);
		resz = ceil(s[2] / rSize);
		region = ds_map_find_first(subdiv);
		while !is_undefined(region)
		{
			ds_list_destroy(subdiv[? region]);
			region = ds_map_find_next(subdiv, region);
		}
		ds_map_destroy(subdiv);
		break;
		
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Generate quadtree or octree
	case eColMeshSubdiv.Quadtree:
	case eColMeshSubdiv.Octree:
		var oct, gridW, gridH, u, v;
		oct = (colMesh[| eColMesh.Type] == eColMeshSubdiv.Octree);
		gridW = oct ? 8 : 4;
		gridH = ds_grid_height(subdiv);
		for (u = 0; u < gridW; u ++)
		{
			for (v = 0; v < gridH; v ++)
			{
				if subdiv[# u, v] < 0
				{
					ds_list_destroy(-subdiv[# u, v]);
				}
			}
		}
		ds_grid_destroy(subdiv);
		break;
}
ds_list_destroy(colMesh);