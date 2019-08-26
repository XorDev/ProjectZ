/// @description smf_tri_in_square(triVerts[12], boxhalfSize, boxCenterX, boxCenterY)
/// @param triVerts[12]
/// @param boxhalfSize
/// @param boxCenterX
/// @param boxCenterY

/********************************************************/
/* AABB-triangle overlap test code                      */
/* by Tomas Akenine-Möller                              */
/* Function: int triBoxOverlap(float boxcenter[3],      */
/*          float boxhalfsize[3],float triverts[3][3]); */
/* History:                                             */
/*   2001-03-05: released the code in its first version */
/*   2001-06-18: changed the order of the tests, faster */
/*                                                      */
/* Acknowledgement: Many thanks to Pierre Terdiman for  */
/* suggestions and discussions on how to optimize code. */
/* Thanks to David Hunt for finding a ">="-bug!         */
/********************************************************/
/*    
Use separating axis theorem to test overlap between triangle and box
need to test for overlap in these directions:
1) the {x,y,z}-directions (actually, since we use the AABB of the triangle we do not even need to test these)
2) normal of the triangle
3) crossproduct(edge from tri, {x,y,z}-directin)
this gives 3x3=9 more tests 
*/
gml_pragma("forceinline");

var bX, bY, bHalfSize, triVerts;
triVerts = argument[0];
bHalfSize = argument[1];
bX = argument[2];
bY = argument[3];

/* test in X-direction */
var v0x, v1x, v2x;
v0x = triVerts[0] - bX;
v1x = triVerts[3] - bX;
v2x = triVerts[6] - bX;
if (min(v0x, v1x, v2x) > bHalfSize || max(v0x, v1x, v2x) < -bHalfSize){return false;}

/* test in Y-direction */
var v0y, v1y, v2y;
v0y = triVerts[1] - bY;
v1y = triVerts[4] - bY;
v2y = triVerts[7] - bY;
if (min(v0y, v1y, v2y) > bHalfSize || max(v0y, v1y, v2y) < -bHalfSize){return false;}

/* Bullet 3:  */
var p1, p2, ex, ey, rad;
ex = v1x - v0x;
ey = v1y - v0y;
p1 = ey * v1x - ex * v1y;                 
p2 = ey * v2x - ex * v2y;         
rad = (abs(ex) + abs(ey)) * bHalfSize;
if (min(p1, p2) > rad || max(p1, p2) < -rad){return false;}

ex = v2x - v1x;
ey = v2y - v1y;
p1 = ey * v0x - ex * v0y;
p2 = ey * v1x - ex * v1y;
rad = (abs(ex) + abs(ey)) * bHalfSize;
if (min(p1, p2) > rad || max(p1, p2) < -rad){return false;}

ex = v0x - v2x;
ey = v0y - v2y;	
p1 = ey * v1x - ex * v1y;
p2 = ey * v2x - ex * v2y;
rad = (abs(ex) + abs(ey)) * bHalfSize;
if (min(p1, p2) > rad || max(p1, p2) < -rad){return false;}

return true;