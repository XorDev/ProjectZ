/// @arg vpl
var vpl = argument0;

var rtW = vpl[11];
var rtH = vpl[12];

var eqW = vpl[13];
var eqH = vpl[14];

vpl[@  9] = GenBuffer(vpl[ 9], rtW, rtH); // Cubemap
vpl[@ 10] = GenBuffer(vpl[10], eqW, eqH); // Equirectangular 
