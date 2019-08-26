if( global.DEBUG || !window_has_focus() || global.MODE[eMode.Any] ) { exit; }

// Look around
var gw = surface_get_width(application_surface);
var gh = surface_get_height(application_surface);

var dx = display_mouse_get_x() - window_get_x() - gw * .5;
var dy = display_mouse_get_y() - window_get_y() - gh * .5;

fDir   -= dx / 10;
fPitch += dy / 10;

// Reset cursor position
display_mouse_set(window_get_x() + gw * .5, window_get_y() + gh * .5);

// Walk around
var move1 = keyboard_check(ord("W")) - keyboard_check(ord("S"));
var move2 = keyboard_check(ord("D")) - keyboard_check(ord("A"));

// 
fSpd = lerp(fSpd, max_fSpd * max(abs(move1), abs(move2)), .2);

x += lengthdir_x(move1 * fSpd, fDir);
y += lengthdir_y(move1 * fSpd, fDir);
z += lengthdir_y(move1 * fSpd, fPitch);

x += lengthdir_x(abs(move2) * fSpd, fDir - 90 * move2);
y += lengthdir_y(abs(move2) * fSpd, fDir - 90 * move2);

// 
fPitch = clamp(fPitch, -89, 89);

// Create view matrix
fx = x;
fy = y;
fz = z + 30;

tx = x + 10 * dcos(fDir);
ty = y - 10 * dsin(fDir);
tz = z + 30 - 10 * dtan(fPitch);

mView = matrix_build_lookat(fx, fy, fz, tx, ty, tz, 0, 0, 1);

// Set directional light
if( keyboard_check_pressed(vk_space) ) {
    objRenderer.bUpdateLight = true;
    with( objLightDirectional ) {
        x = other.x;
        y = other.y;
        z = other.z;
        fDir = other.fDir;
        fPitch = other.fPitch;
        
        show_debug_message(trace2(
            "x = ", x, "\n", 
            "y = ", y, "\n", 
            "z = ", z, "\n", 
            "fDir = "  , fDir, "\n", 
            "fPitch = ", fPitch
        ));
    }
}

