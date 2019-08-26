/// @arg {matrix} View
/// @arg {float3} Vector
var t = dtan(fFOV * .5);
var x0 = WIDTH / HEIGHT * t * (    2 * argument1[0] / WIDTH - 1) * argument1[2];
var y0 =                  t * (1 - 2 * argument1[1] / HEIGHT   ) * argument1[2];

return [
    tx + fx*0 + x0 * argument0[0] + y0 * argument0[1] + argument1[2] * argument0[2 ], 
    ty + fy*0 + x0 * argument0[4] + y0 * argument0[5] + argument1[2] * argument0[6 ], 
    tz + fz*0 + x0 * argument0[8] + y0 * argument0[9] + argument1[2] * argument0[10]
];
