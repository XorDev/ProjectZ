/// @description smf_colmesh_init()
/*
Initializes the SMF collision system

Script made by TheSnidr
www.TheSnidr.com
*/
enum eColMesh
{
	Type, SubdivDS, TriangleList, MinRegionSize, Offset,
	Size, BleedOver, Depth, 
	Matrix, InvMatrix, DeltaMatrix, Scale
}
	
enum eColMeshSubdiv
{
	None, Lattice, SpatialHash, Quadtree, Octree
}
	
global.ColMeshStack = ds_stack_create();
global.ColMeshPriority = ds_priority_create();