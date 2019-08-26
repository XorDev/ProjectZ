/// @arg size
var _size = argument0;
var _surface = surface_create( _size, _size );

surface_set_target( _surface );
draw_clear( c_white );

for( var xx = 0; xx <= _size; xx++ ){
    for( var yy = 0; yy < _size; yy++ ){
    
        var r,g,mag;
        r = random(2) - 1;
        g = random(2) - 1;
        mag = sqrt((r * r) + (g * g));
        r /= mag;
        g /= mag;
        
        //draw_point_color(xx-1, yy, make_color_rgb(floor(r*255), floor(g*255), floor(b)));
        draw_point_color(xx-1, yy, make_color_rgb(floor(((r/2)+0.5) * 255),  floor(((g/2)+0.5) * 255), 127)); 
    }
}
 
surface_reset_target();

return _surface;
