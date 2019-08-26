/// @arg fname
var fname = argument0;

if( !file_exists(fname) ) return -1;

var ext = filename_ext(fname);
if( ext == ".tga" ) {
    var tga = LoadTGA(fname);
    /*var spr = sprite_create_from_surface(tga, 0, 0, surface_get_width(tga), surface_get_height(tga), 0, 0, 0, 0);
    surface_free(tga);*/
    
    //gpu_set_tex_mip_enable_ext(tga, true);
    return [1, tga];
} else {
    if( global.PNGBuffer[? fname] != undefined && global.PNGBuffer[? fname] > -1 ) {
        return [0, global.PNGBuffer[? fname]];
    }
    
    var t = sprite_add(fname, 1, 0, 0, 0, 0);
    global.PNGBuffer[? fname] = t;
    return [0, t];
}
