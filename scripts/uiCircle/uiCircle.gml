/// @arg cx
/// @arg cy
/// @arg rad
var _x = argument0;
var _y = argument1;
var r  = argument2;

draw_primitive_begin(pr_trianglefan);
    
    draw_vertex_texture(_x, _y, .5, .5);
    
    for( var a = 0; a <= 360; a += 360 / 64 ) { // 64 is draw_set_circle_precision()
        var ox = lengthdir_x(r, a);
        var oy = lengthdir_y(r, a);
        
        // Normalize
        var l = sqrt(sqr(ox) + sqr(oy));
        var u = ox / l;
        var v = oy / l;
        
        // Convert from [-1; 1] to [0; 1], by x * .5 + .5
        u = u * .5 + .5;
        v = v * .5 + .5;
        
        // 
        draw_vertex_texture(_x + ox, _y + oy, u, v);
    }
    
draw_primitive_end();
