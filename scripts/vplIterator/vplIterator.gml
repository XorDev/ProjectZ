/// @arg vpl
/// @arg i
var vpl = argument0;
var i   = argument1;

if( i == -1 ) {
    // Set rt
    surface_set_target(vpl[9]);
    
    // Clear vpl
    draw_clear_alpha(0, 0);
    
    // Set projection matrix
    matrix_set(matrix_projection, vpl[16]);
    
    // 
    return vpl[15];
}

// Set view matrix
var mat = vpl[17];
matrix_set(matrix_view, mat[i]);

// 
return vpl[15];
