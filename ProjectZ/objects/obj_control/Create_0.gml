///@desc Setup system

vGravity = 1;

#region GPU States
State2D = gpu_get_state();

//Enable z-testing and culling for 3D.
gpu_set_ztestenable(1);
gpu_set_cullmode(cull_clockwise);
State3D = gpu_get_state();
#endregion

#region Camera
pX = 0; pY = 0; pZ = -2;
vX = 0; vY = 0; vZ = 0;
aX = 180; aY = 0;
#endregion

#region Matrices
//Create camera and matrices.
view_camera[0] = camera_create();
View = matrix_build_lookat(-10,0,-1,0,0,0,0,0,1);
Proj = matrix_build_projection_perspective_fov(77,16/9,.01,20000);

//Apply matrices to camera.
camera_set_view_mat(view_camera[0],View);
camera_set_proj_mat(view_camera[0],Proj);
#endregion

#region Models
model_format();
mTest = model_begin();
for(var lX = -990;lX<990;lX+=10)
for(var lY = -990;lY<990;lY+=10)
{
	var tZ00,tZ10,tZ01,tZ11,tC;
	tZ00 = height(lX-5,lY-5);
	tZ10 = height(lX+5,lY-5);
	tZ01 = height(lX-5,lY+5);
	tZ11 = height(lX+5,lY+5);
	tC = merge_color($999999,$66EEAA,.5+.5*cos(tZ00/9+28*dcos(lX/90)));
	tC = merge_color(tC,$000000,.2*power(random(1),.2));
	
	model_triangle(mTest,[lX-5,lY-5,tZ00+10],[lX-5,lY+5,tZ01+10],[lX+5,lY-5,tZ10+10],tC);
	model_triangle(mTest,[lX-5,lY+5,tZ01+10],[lX+5,lY+5,tZ11+10],[lX+5,lY-5,tZ10+10],tC);
}
model_end(mTest);
#endregion

#region Collisions
cTest = collider_begin(200,-1000,-1000,1000,1000);

for(var lX = -990;lX<990;lX+=10)
for(var lY = -990;lY<990;lY+=10)
{
	var tZ00,tZ10,tZ01,tZ11;
	tZ00 = height(lX-5,lY-5);
	tZ10 = height(lX+5,lY-5);
	tZ01 = height(lX-5,lY+5);
	tZ11 = height(lX+5,lY+5);
	
	collider_triangle(cTest,[lX-5,lY-5,tZ00+10],[lX-5,lY+5,tZ01+10],[lX+5,lY-5,tZ10+10]);
	collider_triangle(cTest,[lX-5,lY+5,tZ01+10],[lX+5,lY+5,tZ11+10],[lX+5,lY-5,tZ10+10]);
	
}
#endregion