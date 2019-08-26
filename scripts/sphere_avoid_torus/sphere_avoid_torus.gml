/// @description smf_sphere_avoid_torus(tx, ty, tz, tnx, tny, tnz, ringRadius, tubeRadius, x, y, z, radius)
/// @param tx
/// @param ty
/// @param tz
/// @param tnx
/// @param tny
/// @param tnz
/// @param innerRadius
/// @param outerRadius
/// @param x
/// @param y
/// @param z
/// @param radius
/*
Makes the sphere (x, y, z) avoid the given torus at position (tx, ty, tz) with normal (tnx, tny, tnz) and radiuses ringRadius and tubeRadius

Returns an array of the following format:
[x, y, z, nx, ny, nz, collision (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
//Torus
var tx, ty, tz, tnx, tny, tnz, rr, tr;
tx = argument0;
ty = argument1;
tz = argument2;
tnx = argument3;
tny = argument4;
tnz = argument5;
rr = argument6;
tr = argument7;

//Sphere
var px, py, pz, pr;
px = argument8;
py = argument9;
pz = argument10;
pr = argument11;

//AABB test - Exit if the sphere is outside the torus' axis-aligned bounding box
var dx, dy, dz;
dx = px - tx;
dy = py - ty;
dz = pz - tz;
if max(abs(dx), abs(dy), abs(dz)) > rr + tr + pr{
	return [px, py, pz, 0, 0, 1, false];}

//Axial test - Exit if the sphere is too far away in the axial direction
var d = dx * tnx + dy * tny + dz * tnz;
if abs(d) > tr + pr{
	return [px, py, pz, 0, 0, 1, false];}

//Orthogonalize to the plane defined by the torus' normal
dx -= tnx * d;
dy -= tny * d;
dz -= tnz * d;

//Normalize the orthogonalized position and multiply by the radius of the ring
var s, sx, sy, sz;
s = rr / max(sqrt(sqr(dx) + sqr(dy) + sqr(dz)), 0.00001);
sx = tx + dx * s;
sy = ty + dy * s;
sz = tz + dz * s;

//Avoiding the torus can now be simplified to avoiding a sphere
return sphere_avoid_sphere(sx, sy, sz, tr, px, py, pz, pr);