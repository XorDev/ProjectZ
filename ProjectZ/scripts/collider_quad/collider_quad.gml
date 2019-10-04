///@desc collider_triangle
///@arg list
///@arg p1
///@arg p2
///@arg p3

var vP1,vP2,vP3;
vP1 = argument[1];
vP2 = argument[2];
vP3 = argument[3];

var vP4;
vP4 = [vP1[0]-vP2[0]+vP3[0],vP1[1]-vP2[1]+vP3[1],vP1[2]-vP2[2]+vP3[2]];

collider_triangle(argument[0],vP1,vP2,vP3);
collider_triangle(argument[0],vP1,vP3,vP4);