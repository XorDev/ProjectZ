/// @desc Window resize
var ww = WIDTH;
var wh = HEIGHT;
var sw = surface_get_width(application_surface);
var sh = surface_get_height(application_surface);

if( ww != sw || wh != sh ) {
    //window_set_size(ww, wh);
    display_set_gui_size(ww, wh);
    surface_resize(application_surface, ww, wh);
    camera_set_view_size(view_camera[0], ww, wh);
    
    view_wport = ww;
    view_hport = wh;
    
    //draw_flush();
    //draw_texture_flush();
    
    with( objCamera ) {
        fAspect = ww / wh;
        mProj = matrix_build_projection_perspective_fov(fFOV, fAspect, fNear, fFar);
        mInvProj = matrix_inverse(mProj);
    }
    
    // Resize debug panel
    /*var q = uipDebug;
    var l = q[0];
    var t = l[| q[1]];
    
    t[@ 2] = ww / 3;
    t[@ 3] = wh;*/
}

if( keyboard_check(vk_shift) ) {
    if( keyboard_check_pressed(vk_up) && (ww != display_get_width()) ) {
        __Size = [ww, wh];
        window_set_size(display_get_width(), display_get_height());
        display_set_gui_size(display_get_width(), display_get_height());
        surface_resize(application_surface, display_get_width(), display_get_height());
        camera_set_view_size(view_camera[0], display_get_width(), display_get_height());
        
        view_wport = display_get_width();
        view_hport = display_get_height();
        
        alarm[0] = 2;
    }
    
    if( keyboard_check_pressed(vk_down) && (ww == display_get_width()) ) {
        window_set_size(__Size[0], __Size[1]);
        display_set_gui_size(__Size[0], __Size[1]);
        surface_resize(application_surface, __Size[0], __Size[1]);
        camera_set_view_size(view_camera[0], __Size[0], __Size[1]);
        
        view_wport = __Size[0];
        view_hport = __Size[1];
        
        alarm[0] = 2;
    }
}
