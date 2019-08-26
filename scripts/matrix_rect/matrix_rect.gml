/// @arg x1
/// @arg y1
/// @arg x2
/// @arg y2
var a = matrix_transform_vertex(matrix_get(matrix_world), 0, 0, 0);
var m = [a[0] + argument0, a[1] + argument1, 
         a[0] + argument2, a[1] + argument3];

if( SV_ClipRectangle != -1 && !rectangle_in_rectangle(SV_ClipRectangle[0], SV_ClipRectangle[1], 
                                                      SV_ClipRectangle[2], SV_ClipRectangle[3], 
                                                      m[0], m[1], m[2], m[3]) ) {
    // Not inside of clip rectangle
    return false;
}

return point_in_rectangle(__uiMX, __uiMY, m[0], m[1], m[2], m[3]);
