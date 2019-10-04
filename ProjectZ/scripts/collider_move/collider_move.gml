///@desc collider_move
///@arg collider
///@arg position
///@arg velocity
///@arg radius

var vCollider,vP,vV,vR;
vCollider = argument[0];
vP  = argument[1];
vV  = argument[2];
vR = argument[3];

var I,vL,lX,lY;
I = 0;
lX = floor( (vP[0] -vCollider[2]) /(vCollider[4]-vCollider[2]) *vCollider[1]);
lY = floor( (vP[1] -vCollider[3]) /(vCollider[5]-vCollider[3]) *vCollider[1]);
if (lX>=0) & (lX<vCollider[1]) & (lY>=0) & (lY<vCollider[1])
{
	vL = ds_grid_get(vCollider[0],lX,lY);

	for(var I = 0;I<ds_list_size(vL)/9;I++)
	{	
		var vP0,vP1,vP2,vP3;
		vP0 = vector_add(vP,vV);
		vP1 = [ds_list_find_value(vL,I*9+0),ds_list_find_value(vL,I*9+1),ds_list_find_value(vL,I*9+2)];
		vP2 = [ds_list_find_value(vL,I*9+3),ds_list_find_value(vL,I*9+4),ds_list_find_value(vL,I*9+5)];
		vP3 = [ds_list_find_value(vL,I*9+6),ds_list_find_value(vL,I*9+7),ds_list_find_value(vL,I*9+8)];

		var vN,vV1,vV2,vV3,vC1,vC2,vC3;
		vN = vector_cross_norm(vector_subtract(vP1,vP3),vector_subtract(vP2,vP3));
	
		vV1 = vector_subtract(vP1,vP0);
		vV2 = vector_subtract(vP2,vP0);
		vV3 = vector_subtract(vP3,vP0);

		vC1 = vector_cross(vN,vector_subtract(vP1,vP2));
		vC2 = vector_cross(vN,vector_subtract(vP2,vP3));
		vC3 = vector_cross(vN,vector_subtract(vP3,vP1));

		var C,S;
		C = (vector_dot(vC1,vV1)>-vR)&(vector_dot(vC2,vV2)>-vR)&(vector_dot(vC3,vV3)>-vR);
		S = vector_dot(vector_subtract(vP1,vP0),vN);
		S = -max(vR-abs(S),0)*sign(S)*C/2;
		vV = vector_add(vV,[vN[0]*S,vN[1]*S,vN[2]*S]);
	}
}
return vV;