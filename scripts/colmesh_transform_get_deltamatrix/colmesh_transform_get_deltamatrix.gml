/// @description smf_colmesh_transform_get_deltamatrix(colMesh)
/// @param colMesh
/*
Returns the delta matrix of the colmesh. This is useful for transforming any objects that are supposed to be
attached to the surface of the colmesh, so that they stay in the same position relative to the mesh.

Mesh must have been transformed first, otherwise it'll return -1.

Script made by TheSnidr
www.TheSnidr.com
*/
var colMesh = argument0;
return colMesh[| eColMesh.DeltaMatrix];