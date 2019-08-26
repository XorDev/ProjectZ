/// @description
cam_3d_enable();

cam_create(0, 80, room_width / room_height, 1, 32000);


yaw = 0;
pitch = 0;
z = 200;

dirX = 1;
dirY = 0;
dirZ = 0;

prevX = x;
prevY = y;
prevZ = z;

radius = 16;

window_mouse_set(room_width / 2, room_height / 2);