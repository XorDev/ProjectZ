/// @arg angle
/// @arg pointCount
/// @arg radius
var a = argument0; // Cause wrong colors on the wheel
var c = argument1;
var r = argument2;

var s = 360 / c; // Step
var bias = 1;

var ox = lengthdir_x(r, a);
var oy = lengthdir_y(r, a);

// Normalize
var l = sqrt(sqr(ox) + sqr(oy));
var u = ox / l;
var v = oy / l;

// Convert from [-1; 1] to [0; 1], by x * .5 + .5
u = u * .5 + .5;
v = v * .5 + .5;

//show_debug_message([u, v]);
switch( c ) {
    case 1: return make_color_rgb((1 - u) * 255, (1 - v) * 255, v * 255);
        
    case 2:
        var ox2 = lengthdir_x(r, a + s);
        var oy2 = lengthdir_y(r, a + s);
        
        // Normalize
        var l = sqrt(sqr(ox2) + sqr(oy2)) * bias;
        var u2 = ox2 / l;
        var v2 = oy2 / l;
        var q2 = v2;
        
        // Convert from [-1; 1] to [0; 1], by x * .5 + .5
        u2 = 1 - (u2 * .5 + .5);
        v2 = 1 - (v2 * .5 + .5);
        q2 = q2 * .5 + .5;
        
        //show_debug_message([1 - u, 1 - v, v, u2, v2, q2]);
        return merge_color(make_color_rgb(255 * (1 - u), 255 * (1 - v), 255 * v), make_color_rgb(255 * u2, 255 * v2, 255 * q2), 1 / 2);
        
    case 3:
        var ox2 = lengthdir_x(r, a + s);
        var oy2 = lengthdir_y(r, a + s);
        
        // Normalize
        var l = sqrt(sqr(ox2) + sqr(oy2));
        var u2 = 1 - ox2 / l;
        var v2 = oy2 / l;
        var q2 = v2;
        
        v2 = 1 - v2;
        
        // Convert from [-1; 1] to [0; 1], by x * .5 + .5
        u2 = u2 * .5 + .5;
        v2 = v2 * .5 + .5;
        
        var ox3 = lengthdir_x(r, a + s * 2);
        var oy3 = lengthdir_y(r, a + s * 2);
        
        // Normalize
        var l = sqrt(sqr(ox3) + sqr(oy3));
        var u3 = 1 - ox3 / l;
        var v3 = oy3 / l;
        var q3 = v3;
        
        v3 = 1 - v3;
        
        // Convert from [-1; 1] to [0; 1], by x * .5 + .5
        u3 = u3 * .5 + .5;
        v3 = v3 * .5 + .5;
        
        return make_color_rgb(255 * (1 - u + u2 + u3) / 3, 255 * (1 - v + v2 + v3) / 3, 255 * (v + q2 + q3) / 3);
        
    case 4:
        var ox2 = lengthdir_x(r, a + s);
        var oy2 = lengthdir_y(r, a + s);
        
        // Normalize
        var l = sqrt(sqr(ox2) + sqr(oy2));
        var u2 = 1 - ox2 / l;
        var v2 = oy2 / l;
        var q2 = v2;
        
        v2 = 1 - v2;
        
        // Convert from [-1; 1] to [0; 1], by x * .5 + .5
        u2 = u2 * .5 + .5;
        v2 = v2 * .5 + .5;
        
        var ox3 = lengthdir_x(r, a + s * 2);
        var oy3 = lengthdir_y(r, a + s * 2);
        
        // Normalize
        var l = sqrt(sqr(ox3) + sqr(oy3));
        var u3 = 1 - ox3 / l;
        var v3 = oy3 / l;
        var q3 = v3;
        
        v3 = 1 - v3;
        
        // Convert from [-1; 1] to [0; 1], by x * .5 + .5
        u3 = u3 * .5 + .5;
        v3 = v3 * .5 + .5;
        
        var ox4 = lengthdir_x(r, a + s * 3);
        var oy4 = lengthdir_y(r, a + s * 3);
        
        // Normalize
        var l = sqrt(sqr(ox4) + sqr(oy4));
        var u4 = 1 - ox4 / l;
        var v4 = oy4 / l;
        var q4 = v4;
        
        v4 = 1 - v4;
        
        // Convert from [-1; 1] to [0; 1], by x * .5 + .5
        u4 = u4 * .5 + .5;
        v4 = v4 * .5 + .5;
        
        return make_color_rgb(255 * (1 - u + u2 + u3 + u4) / 4, 255 * (1 - v + v2 + v3 + v4) / 4, 255 * (v + q2 + q3 + q4) / 4);
}

return 0;