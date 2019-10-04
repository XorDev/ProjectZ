///@desc vector_cross
///@arg v1
///@arg v2

var vV1,vV2;
vV1 = argument[0];
vV2 = argument[1];

var vX,vY,vZ;
vX = vV1[1]*vV2[2]-vV1[2]*vV2[1];
vY = vV1[2]*vV2[0]-vV1[0]*vV2[2];
vZ = vV1[0]*vV2[1]-vV1[1]*vV2[0];

return [vX,vY,vZ];