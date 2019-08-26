/// @description smf_cast_ray_sphere(sx, sy, sz, r, x1, y1, z1, x2, y2, z2)
/// @param sx
/// @param sy
/// @param sz
/// @param r
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a sphere centered at (sx,sy,sz) with radius r.

Returns the intersection as an array of the following format:
[x, y, z, nx, ny, nz, intersection (true or false)]

Script made by TheSnidr

www.thesnidr.com
*/
var sx, sy, sz, r;
sx = argument0;
sy = argument1;
sz = argument2;
r = argument3;

var x1, y1, z1;
x1 = argument4;
y1 = argument5;
z1 = argument6;

var x2, y2, z2;
x2 = argument7;
y2 = argument8;
z2 = argument9;

var dx, dy, dz;
dx = sx - x1;
dy = sy - y1;
dz = sz - z1;

var vx, vy, vz;
vx = x2 - x1;
vy = y2 - y1;
vz = z2 - z1;

//dp is now the distance from the starting point to the plane perpendicular to the ray direction, times the length of dV
var dp, l, d;
dp = dot_product_3d(dx, dy, dz, vx, vy, vz);

//d is the remaining distance from this plane to the surface of the sphere, times the length of dV
l = sqr(vx) + sqr(vy) + sqr(vz);
d = sqr(dp) + l * (sqr(r) - sqr(dx) - sqr(dy) - sqr(dz));

//If d is less than 0, there is no intersection
if (d < 0){return [x2, y2, z2, 0, 0, 1, false];}

//If dp is less than d, it means that the ray is cast from within the sphere. We therefore need to add d to dp, since the intersection point will then be on the inside surface of the sphere
d = sqrt(d);
if (dp < d){
	dp += d; 
	if (dp < 0){
		return [x2, y2, z2, 0, 0, 1, false];}}
else{dp -= d;}

//Find the point of intersection
var px, py, pz;
l = dp / l;
px = x1 + vx * l;
py = y1 + vy * l;
pz = z1 + vz * l;

//Find the intersection normal
var nx, ny, nz, n;
nx = px - sx;
ny = py - sy;
nz = pz - sz;
n = 1 / max(sqrt(sqr(nx) + sqr(ny) + sqr(nz)), 0.00001);
nx *= n;
ny *= n;
nz *= n;

return [px, py, pz, nx, ny, nz, true];
