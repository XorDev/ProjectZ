///@desc model_quad
///@arg vbuff
///@arg p1
///@arg p2
///@arg p3
///@arg color
/*
	Add a quad to a model.
	P1, p2 and p3 are points (vertices) defined by 1D arrays with x, y and z values.
	Color is the quad color (for all vertices).
*/

var vP1,vP2,vP3,vP4;
vP1 = argument[1];
vP2 = argument[2];
vP3 = argument[3];
vP4 = [vP1[0]-vP2[0]+vP3[0],vP1[1]-vP2[1]+vP3[1],vP1[2]-vP2[2]+vP3[2]];

model_triangle(argument[0],vP1,vP2,vP3,argument[4]);
model_triangle(argument[0],vP1,vP3,vP4,argument[4]);