///@desc vector_cross_norm
///@arg v1
///@arg v2

var vV1,vV2;
vV1 = argument[0];
vV2 = argument[1];

var vX,vY,vZ,vL;
vX = vV1[1]*vV2[2]-vV1[2]*vV2[1];
vY = vV1[2]*vV2[0]-vV1[0]*vV2[2];
vZ = vV1[0]*vV2[1]-vV1[1]*vV2[0];
vL = sqrt(sqr(vX)+sqr(vY)+sqr(vZ));

return [vX/vL,vY/vL,vZ/vL];