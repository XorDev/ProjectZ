///@desc model_triangle
///@arg vbuff
///@arg p1
///@arg p2
///@arg p3
///@arg color
/*
	Add a triangle to a model.
	P1, p2 and p3 are points (vertices) defined by 1D arrays with x, y and z values.
	Color is the triangle color (for all vertices).
*/

var vP1,vP2,vP3;
vP1 = argument[1];
vP2 = argument[2];
vP3 = argument[3];

//Calculate surface normal using a normalized cross product.
var vNX,vNY,vNZ,vNL;
vNX = (vP1[1]-vP3[1])*(vP2[2]-vP3[2])-(vP1[2]-vP3[2])*(vP2[1]-vP3[1]);
vNY = (vP1[2]-vP3[2])*(vP2[0]-vP3[0])-(vP1[0]-vP3[0])*(vP2[2]-vP3[2]);
vNZ = (vP1[0]-vP3[0])*(vP2[1]-vP3[1])-(vP1[1]-vP3[1])*(vP2[0]-vP3[0]);
vNL = sqrt(sqr(vNX)+sqr(vNY)+sqr(vNZ));
vNX /= vNL; vNY /= vNL; vNZ /= vNL;

vertex_position_3d(argument[0],vP1[0],vP1[1],vP1[2]);
vertex_color(argument[0],argument[4],1);
vertex_normal(argument[0],vNX,vNY,vNZ);

vertex_position_3d(argument[0],vP2[0],vP2[1],vP2[2]);
vertex_color(argument[0],argument[4],1);
vertex_normal(argument[0],vNX,vNY,vNZ);

vertex_position_3d(argument[0],vP3[0],vP3[1],vP3[2]);
vertex_color(argument[0],argument[4],1);
vertex_normal(argument[0],vNX,vNY,vNZ);