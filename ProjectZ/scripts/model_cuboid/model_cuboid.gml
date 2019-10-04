///@desc model_cuboid
///@arg vbuff
///@arg p1
///@arg p2
///@arg color
/*
	Add a cuboid to a model.
	P1 and p2 are points (vertices) on opposite sides defined by 1D arrays with x, y and z values.
	Color is the cuboid color (for all vertices).
*/

var vP1,vP2;
vP1 = argument[1];
vP2 = argument[2];

var vV1,vV2,vV3,vV4,vV5,vV6,vV7,vV8;
vV1 = [vP1[0],vP1[1],vP1[2]]; vV2 = [vP2[0],vP1[1],vP1[2]];
vV3 = [vP1[0],vP2[1],vP1[2]]; vV4 = [vP2[0],vP2[1],vP1[2]];
vV5 = [vP1[0],vP1[1],vP2[2]]; vV6 = [vP2[0],vP1[1],vP2[2]];
vV7 = [vP1[0],vP2[1],vP2[2]]; vV8 = [vP2[0],vP2[1],vP2[2]];

model_quad(argument[0],vV1,vV5,vV7,argument[3]);
model_quad(argument[0],vV2,vV4,vV8,argument[3]);
model_quad(argument[0],vV1,vV2,vV6,argument[3]);
model_quad(argument[0],vV3,vV7,vV8,argument[3]);
model_quad(argument[0],vV4,vV2,vV1,argument[3]);
model_quad(argument[0],vV5,vV6,vV8,argument[3]);