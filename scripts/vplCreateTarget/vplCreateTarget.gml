/// @arg u Lightmap dim per VPL
/// @arg v Lightmap dim per VPL
/// @arg xd Dims
/// @arg yd Dims
/// @arg zd Dims
/// @arg xo Origin
/// @arg yo Origin
/// @arg zo Origin
/// @arg Spacing
var u = argument0;
var v = argument1;

var xd = argument2;
var yd = argument3;
var zd = argument4;

var xo = argument5;
var yo = argument6;
var zo = argument7;

var sp = argument8;

// Render Target
// RT for single VPL: 6 * u, v

var rtW = u * 6 * xd * yd;
var rtH = v * zd;

var eqW = rtW / 1.5;
var eqH = rtH * 2.;

var surfRT = -1;
var surfEq = -1;
 
var dim = xd * yd * zd * 6;

var matProj = matrix_build_projection_perspective(u, v, 1.1, 10000);
var matView; matView[dim] = -1;

// Create matrices for each VPL and each Cubemap Side
for( var i = 0; i < xd; i++ ) 
for( var j = 0; j < yd; j++ ) 
for( var k = 0; k < zd; k++ ) 
for( var l = 0; l <  6; l++ ) {
    
}

//      0  1  2   3   4   5   6   7   8
return [u, v, xd, yd, zd, xo, yo, zo, sp, 
//      9       10      11   12   13   14
        surfRT, surfEq, rtW, rtH, eqW, eqH, 
//      15   16       17
        dim, matProj, matView];

