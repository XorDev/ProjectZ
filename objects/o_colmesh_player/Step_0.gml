/// @description

//Mouse control
var mouseDx = window_mouse_get_x() - room_width / 2;
var mouseDy = window_mouse_get_y() - room_height / 2;
window_mouse_set(room_width / 2, room_height / 2);

yaw = (yaw + mouseDx / 10 + 360) mod 360
pitch = clamp(pitch - mouseDy / 10, -89, 89);

dirX = dcos(yaw) * dcos(pitch);
dirY = dsin(yaw) * dcos(pitch);
dirZ = dsin(pitch);

//Verlet integration
fric = 0.7;
spdX = (x - prevX) * fric;
spdY = (y - prevY) * fric;
spdZ = (z - prevZ) * 0.99;
prevX = x;
prevY = y;
prevZ = z;

//Controls
var h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var v = keyboard_check(ord("W")) - keyboard_check(ord("S"));
var jump = keyboard_check_pressed(vk_space);
var m = 1 / max(1, sqrt(sqr(h) + sqr(v)));
h *= m;
v *= m;

//Move
acc = 1.5;
x += spdX + acc * (v * dirX - h * dirY);
y += spdY + acc * (v * dirY + h * dirX);
z += spdZ - 0.4;

//Find the current region of the collision mesh
region = colmesh_get_region(levelColmesh, x, y, z);

//Cast a short-range ray from the previous position to the current position to avoid going through geometry
ray = cast_ray_colmesh_region(levelColmesh, region, prevX, prevY, prevZ, x, y, z);
if ray[6]
{
	x = ray[0] + ray[3] * radius / 2;
	y = ray[1] + ray[4] * radius / 2;
	z = ray[2] + ray[5] * radius / 2;
}

//Avoid ground
col = sphere_avoid_colmesh_region(levelColmesh, region, x, y, z, radius, 0, 0, 1, 30);
if col[6] //If we're touching ground
{
	x = col[0];
	y = col[1];
	z = col[2];
	
	if jump && col[5] > 0.7
	{
		z += 10;
	}
}

//Move camera
cam_set_viewmat(view_camera[0], x, y, z + 16, x + dirX, y + dirY, z + 16 + dirZ, 0, 0, 1);