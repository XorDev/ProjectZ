/// @arg mat
/// @arg vec4
var mat = argument0;
var Vec = argument1;

var v = [0, 0, 0, 0];
for( var i = 0; i < 4; i++ ) 
    v[i] = mat[i * 4 + 0] * Vec[0] + mat[i * 4 + 1] * Vec[1]
         + mat[i * 4 + 2] * Vec[2] + mat[i * 4 + 3] * Vec[3];

return v;
