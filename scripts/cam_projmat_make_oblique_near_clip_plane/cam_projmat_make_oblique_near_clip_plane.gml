/// @description cam_projmat_make_oblique_near_clip_plane(projMat, clipX, clipY, clipZ, clipZ)
/// @param ProjMat
/// @param clipX
/// @param clipY
/// @param clipZ
/// @param clipW
/*
	Modifies the given projection matrix so that it has an oblique near clip plane.
	Must supply the camera-space 4D vector of the given plane, as well as the projection matrix.
	The resulting projection matrix will mess up your depth buffer and any shaders that use it.
	This is useful for virtual cameras like used in portals or reflections, to prevent anything behind the portal/mirror
	from being rendered.

	Source: http://www.terathon.com/code/oblique.html
	GMC topic: https://forum.yoyogames.com/index.php?threads/projection-matrix-with-oblique-near-clip-plane.60537/
	Adapted to GML by Sindre Hauge Larsen
*/
var P = argument0;

var clipX, clipY, clipZ, clipW;
clipX = argument1;
clipY = argument2;
clipZ = argument3;
clipW = argument4;

//Calculate the clip-space corner point opposite the clipping plane
//as (sgn(clipPlane.x), sgn(clipPlane.y), 1, 1) and
//transform it into camera space by multiplying it
//by the inverse of the projection matrix
var Qx, Qy, Qz, Qw;
Qx = (sign(clipX) + P[8]) / P[0];
Qy = (sign(clipY) + P[9]) / P[5];
Qz = -1;
Qw = (1 + P[10]) / P[14];

//Replace the third row of the projection matrix
var c = 2 / (clipX * Qx + clipY * Qy + clipZ * Qz + clipW * Qw);
P[2]  = clipX * c;
P[6]  = clipY * c;
P[10] = clipZ * c;
P[14] = clipW * c;

return P;