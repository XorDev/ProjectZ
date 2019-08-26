/// @description smf_colmesh_transform_get_matrix(colMesh)
/// @param colMesh
/*
Returns the mesh's world matrix

Mesh must have been transformed first, otherwise it'll return -1.

Script made by TheSnidr
www.TheSnidr.com
*/
var colMesh = argument0;
return colMesh[| eColMesh.Matrix];