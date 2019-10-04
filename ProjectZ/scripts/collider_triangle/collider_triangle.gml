///@desc collider_triangle
///@arg collider
///@arg p1
///@arg p2
///@arg p3

var vCollider,vP1,vP2,vP3;
vCollider = argument[0];
vP1 = argument[1];
vP2 = argument[2];
vP3 = argument[3];

//Map the triangle to the cell range as a rectangle.
var lX1,lY1,lX2,lY2;
lX1 = floor((min(vP1[0],vP2[0],vP3[0])-vCollider[2]) / (vCollider[4]-vCollider[2])*vCollider[1]);
lY1 = floor((min(vP1[1],vP2[1],vP3[1])-vCollider[3]) / (vCollider[5]-vCollider[3])*vCollider[1]);
lX2 =  ceil((max(vP1[0],vP2[0],vP3[0])-vCollider[2]) / (vCollider[4]-vCollider[2])*vCollider[1]);
lY2 =  ceil((max(vP1[1],vP2[1],vP3[1])-vCollider[3]) / (vCollider[5]-vCollider[3])*vCollider[1]);

//Clamp the range so it won't throw an error for triangles outside of the map.
lX1 = clamp(lX1,0,vCollider[1]); lY1 = clamp(lY1,0,vCollider[1]);
lX2 = clamp(lX2,0,vCollider[1]); lY2 = clamp(lY2,0,vCollider[1]);

//Loop through the grid and add the triangle.
for(var lX = lX1; lX<lX2; lX++)
for(var lY = lY1; lY<lY2; lY++)
{
	ds_list_add(ds_grid_get(vCollider[0],lX,lY), vP1[0], vP1[1], vP1[2], vP2[0], vP2[1], vP2[2], vP3[0], vP3[1], vP3[2]);
}