/// @description smf_colmesh_transform(colMesh, matrix)
/// @param colMesh
/// @param matrix
/*
This script lets you make it seem like a colmesh has been transformed.
What really happens though, is that the collision shape is transformed by the inverse of the given matrix, 
then it performs collision checks, and then it is transformed back. This is an efficient process.
This script creates a new matrix from the given matrix, making sure that all the vectors are perpendicular, 
and making sure the scaling is uniform (using the scale along the x-dimension as reference).

The script also creates a delta matrix. This is useful for transforming any objects that are supposed to be
attached to the surface of the colmesh, so that they stay in the same position relative to the mesh.

Script made by TheSnidr
www.TheSnidr.com
*/
gml_pragma("forceinline");
var colMesh, M, sqrScale, scale, sideDp, l;
colMesh = argument0;
M = argument1;
sqrScale = sqr(M[0]) + sqr(M[1]) + sqr(M[2]);
scale = sqrt(sqrScale);

//Orthogonalize the side vector
sideDp = (M[0] * M[4] + M[1] * M[5] + M[2] * M[6]) / sqrScale;
M[4] -= M[0] * sideDp;
M[5] -= M[1] * sideDp;
M[6] -= M[2] * sideDp;
l = scale / max(sqrt(sqr(M[4]) + sqr(M[5]) + sqr(M[6])), 0.00001);
M[4] *= l;
M[5] *= l;
M[6] *= l;

//Orthogonalize the up vector
M[8] = (M[1] * M[6] - M[2] * M[5]) / scale;
M[9] = (M[2] * M[4] - M[0] * M[6]) / scale;
M[10]= (M[0] * M[5] - M[1] * M[4]) / scale;

//Remove the 4th value of each vector
M[3] = 0;
M[7] = 0;
M[11]= 0;
M[15] = 1;

//Check if a previous inverted matrix exists. If it does, construct the delta matrix (useful for making the player rotate with the colmesh etc)
if is_array(colMesh[| eColMesh.InvMatrix])
{
	colMesh[| eColMesh.DeltaMatrix] = matrix_multiply(colMesh[| eColMesh.InvMatrix], M);
}
else
{
	colMesh[| eColMesh.DeltaMatrix] = matrix_build_identity();
}

colMesh[| eColMesh.Matrix] = M;
colMesh[| eColMesh.InvMatrix]= mat_invert_fast(M);
colMesh[| eColMesh.Scale] = scale;