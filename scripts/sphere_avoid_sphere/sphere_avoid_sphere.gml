/// @description smf_sphere_avoid_sphere(sphereX, sphereY, sphereZ, sphereRadius, x, y, z, radius)
/// @param sphereX
/// @param sphereY
/// @param sphereZ
/// @param sphereRadius
/// @param x
/// @param y
/// @param z
/// @param radius
/*
Makes the sphere (x, y, z) avoid the given sphere (sphereX, sphereY, sphereZ, sphereRadius)

Returns an array of the following format:
[x, y, z, nx, ny, nz, collision (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var sx, sy, sz, sr;
sx = argument0;
sy = argument1;
sz = argument2;
sr = argument3;

var px, py, pz, pr;
px = argument4;
py = argument5;
pz = argument6;
pr = argument7;

var dx, dy, dz, R;
dx = px - sx;
dy = py - sy;
dz = pz - sz;
R = sr + pr;

//Compare the square of the distance to the square of the combined radii
var d = sqr(dx) + sqr(dy) + sqr(dz);
if ((d >= sqr(R)) || (d == 0)){return [px, py, pz, 0, 0, 1, false];}

//The spheres intersect. Make the object sphere move out of the solid sphere
var nx, ny, nz;
d = 1 / sqrt(d);
nx = dx * d;
ny = dy * d;
nz = dz * d;

px = sx + nx * R;
py = sy + ny * R;
pz = sz + nz * R;

return [px, py, pz, nx, ny, nz, true];