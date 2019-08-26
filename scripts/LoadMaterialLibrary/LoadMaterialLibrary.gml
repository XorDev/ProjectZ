/// @desc LoadMaterialLibrary(fname);
/// @arg fname
var fname = argument0;

var map = ds_map_create();
var m_name = "default";
var data = global.m_MaterialMaps[? filename_name(fname)];
data = ds_map_create(); // Map of texture maps

var file = file_text_open_read(fname);
    
    while( !file_text_eof(file) ) {
        var line = file_text_read_string(file);
        file_text_readln(file);
        
        // Comments
        if( string_pos("#", line) ) {
            line = string_delete(line, string_pos("#", line), string_length(line));
        }
        
        if( string_length(line) == 0 ) continue;
        
        // Delete leading spaces
        while( string_char_at(line, 1) == " " || string_char_at(line, 1) == "\t" ) { line = string_delete(line, 1, 1); }
        
        // Switch over all types that are supported
        switch( string_copy(line, 1, 2) ) {
            case "d ": // Alpha
                var a = map[? m_name];
                
                a[@ 3] = real(string_delete(line, 1, 2)); // "d " was deleted
                break;
                
            case "Ns ": // Reflectivity
                var a = map[? m_name];
                
                a[@ 4] = real(string_delete(line, 1, 3)); // "Ns " was deleted
                break;
                
            case "Ka": // Colour of ambient light (r, g, b)
                var tmp = string_delete(line, 1, 3); // "Ka " was deleted
                var arr = string_split(tmp, " ", true);
                
                var a = map[? m_name];
                a[@ 1] = make_colour_rgb(arr[0] * 255, arr[1] * 255, arr[2] * 255);
                break;
                
            case "Kd": // Diffuse color (r, g, b)
                var tmp = string_delete(line, 1, 3); // "Kd " was deleted
                var arr = string_split(tmp, " ", true);
                
                var a = map[? m_name];
                a[@ 0] = make_colour_rgb(arr[0] * 255, arr[1] * 255, arr[2] * 255);
                break;
                
            case "Ks": // Reflectivity color (r, g, b)
                var tmp = string_delete(line, 1, 3); // "Ks " was deleted
                var arr = string_split(tmp, " ", true);
                
                var a = map[? m_name];
                a[@ 2] = make_colour_rgb(arr[0] * 255, arr[1] * 255, arr[2] * 255);
                break;
                
            case "ma": // Diffuse/Bump/Normal/Mask texture
                var c = string_copy(line, 1, 6);
                switch( c ) {
                    case "map_Kd":
                        var tmp = "Textures\\" + string_delete(line, 1, 7); // Get full path w/ filename
                        show_debug_message("Loading Diffuse map (" + trace(tmp, m_name) + ")");
                        
                        var a = map[? m_name];
                        if( file_exists(tmp) ) {
                            if( a[5] == -1 ) {
                                a[@ 5] = [MaterialTextureLoad(tmp), tmp];
                            } else if( typeof(a[5]) == "array" ) {
                                var h = a[5];
                                a[@ 5] = ds_list_create();
                                ds_list_add(a[5], [h[0], h[1]], [MaterialTextureLoad(tmp), tmp]);
                            } else {
                                ds_list_add(a[5], [MaterialTextureLoad(tmp), tmp]);
                            }
                        } else show_debug_message("Can't load Diffuse map (" + trace(tmp, m_name) + ")");
                        break;
                        
                    case "map_bu": // map_bump 
                        var tmp = "Textures\\" + string_delete(line, 1, 9); // Get full path w/ filename
                        show_debug_message("Loading Bump/Normal map (" + trace(tmp, m_name) + ")");
                        
                        var a = map[? m_name];
                        if( file_exists(tmp) ) {
                            if( a[6] == -1 ) {
                                a[@ 6] = [MaterialTextureLoad(tmp), tmp];
                            } else if( typeof(a[6]) == "array" ) {
                                var h = a[6];
                                a[@ 6] = ds_list_create();
                                ds_list_add(a[6], [h[0], h[1]], [MaterialTextureLoad(tmp), tmp]);
                            } else {
                                ds_list_add(a[6], [MaterialTextureLoad(tmp), tmp]);
                            }
                        } else show_debug_message("Can't load Bump/Normal map (" + trace(tmp, m_name) + ")");
                        break;
                        
                    case "map_d ": // map_d 
                        var tmp = "Textures\\" + string_delete(line, 1, 6); // Get full path w/ filename
                        show_debug_message("Loading Mask map (" + trace(tmp, m_name) + ")");
                        
                        var a = map[? m_name];
                        if( file_exists(tmp) ) {
                            if( a[7] == -1 ) {
                                a[@ 7] = [MaterialTextureLoad(tmp), tmp];
                            } else if( typeof(a[7]) == "array" ) {
                                var h = a[7];
                                a[@ 7] = ds_list_create();
                                ds_list_add(a[7], [h[0], h[1]], [MaterialTextureLoad(tmp), tmp]);
                            } else {
                                ds_list_add(a[7], [MaterialTextureLoad(tmp), tmp]);
                            }
                        } else show_debug_message("Can't load Mask map (" + trace(tmp, m_name) + ")");
                        break;
                        
                    case "map_em": // map_ems
                        var tmp = "Textures\\" + string_delete(line, 1, 8); // Get full path w/ filename
                        show_debug_message("Loading Emission map (" + trace(tmp, m_name) + ")");
                        
                        var a = map[? m_name];
                        if( file_exists(tmp) ) {
                            if( a[8] == -1 ) {
                                a[@ 8] = [MaterialTextureLoad(tmp), tmp];
                            } else if( typeof(a[8]) == "array" ) {
                                var h = a[8];
                                a[@ 8] = ds_list_create();
                                ds_list_add(a[8], [h[0], h[1]], [MaterialTextureLoad(tmp), tmp]);
                            } else {
                                ds_list_add(a[8], [MaterialTextureLoad(tmp), tmp]);
                            }
                        } else show_debug_message("Can't load Emission map (" + trace(tmp, m_name) + ")");
                        break;
                        
                    case "map_mr": // map_mr
                        var tmp = "Textures\\" + string_delete(line, 1, 7); // Get full path w/ filename
                        show_debug_message("Loading Metallic AO Roughness map (" + trace(tmp, m_name) + ")");
                        
                        var a = map[? m_name];
                        if( file_exists(tmp) ) {
                            if( a[9] == -1 ) {
                                a[@ 9] = [MaterialTextureLoad(tmp), tmp];
                            } else if( typeof(a[9]) == "array" ) {
                                var h = a[9];
                                a[@ 9] = ds_list_create();
                                ds_list_add(a[9], [h[0], h[1]], [MaterialTextureLoad(tmp), tmp]);
                            } else {
                                ds_list_add(a[9], [MaterialTextureLoad(tmp), tmp]);
                            }
                        } else show_debug_message("Can't load Metallic AO Roughness map (" + trace(tmp, m_name) + ")");
                        break;
                        
                    default: show_debug_message("I can't parse it yet! (" + trace(line, c) + ")"); break;
                }
                break;
                
            default:
                if( string_pos("newmtl ", line) > 0 ) {
                    m_name = string_delete(line, 1, string_length("newmtl "));
                    
                    map[? m_name] = MaterialCreate();
                } else show_debug_message("I can't parse it yet! (" + line + ")");
                break;
        }
    }
    
file_text_close(file);

// Return material map
return map;
