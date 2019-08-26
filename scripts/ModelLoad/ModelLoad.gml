/// @desc ModelLoad(fname);
/// @arg fname
/// DON'T FORGET TO TRIANGULATE MODEL!
/// 
/// DON'T FORGET TO TRIANGULATE MODEL!
/// 
/// DON'T FORGET TO TRIANGULATE MODEL!
/// 
/// DON'T FORGET TO TRIANGULATE MODEL!
/// 
/// DON'T FORGET TO TRIANGULATE MODEL!
/// 
/// DON'T FORGET TO TRIANGULATE MODEL!
/// 
/// DON'T FORGET TO TRIANGULATE MODEL!
var fname = "Models\\" + argument0;
var mtllib = "Materials\\";
var m_mtl = noone;

var ct = current_time;

if( filename_ext(fname) != ".obj" ) fname += ".obj";
if( !file_exists(fname) ) {
    show_debug_message("Couldn't open .obj file! " + fname);
    return MQ_ERROR;
}

var models = ds_list_create();
var matMap = ds_list_create();

var Bounds = [+9999999, +9999999, +9999999,  // Min
              -9999999, -9999999, -9999999]; // Max

var fileNameCache = "Cache\\" + filename_name(argument0) + ".CPack";
if( !file_exists(fileNameCache) ) {
#region Load obj / mtl files
var lastTangent  = [0, 0, 0];
var lastBinormal = [0, 0, 0];

var lastU = -1;
var ColPosList  = ds_list_create(), 
    ColVtxList  = ds_list_create(), 
    ColPosStack = ds_stack_create();

var vertices = ds_list_create();
var texCoord = ds_list_create();
var normals  = ds_list_create();

var m_model = -1;

var ____q = false;

var materialDefault = MaterialCreate();
var CurrentMaterial = materialDefault;
    
    var file = file_text_open_read(fname);
            
            while( !file_text_eof(file) ) {
                if( ____q ) { break; }
                
                var line = file_text_read_string(file);
                file_text_readln(file);
                
                // Comments
                if( string_pos("#", line) ) {
                    if( ML_showComments ) show_debug_message(string_copy(line, string_pos("#", line), string_length(line)));
                    line = string_delete(line, string_pos("#", line), string_length(line));
                }
                
                if( string_length(line) == 0 ) continue;
                
                // 
                switch( string_copy(line, 1, 2) ) {
                    case "v ": // Vertices (x, y, z)
                        ds_list_add(vertices, string_split(string_delete(line, 1, 2 + (string_char_at(line, 3) == " ")), " ", true));
                        break;
                        
                    case "vt": // Texture coordinates (u, v)
                        ds_list_add(texCoord, string_split(string_delete(line, 1, 3), " ", true));
                        break;
                        
                    case "vn": // Normals (xn, yn, zn)
                        ds_list_add(normals, string_split(string_delete(line, 1, 3), " ", true));
                        break;
                        
                    case "f ": // Face (v1/vt1/vn1, v2/vt2/vn2, v3/vt3/vn3)
                        if( m_model == -1 ) { // Create new vertex buffer
                            m_model = vertex_create_buffer();
                            vertex_begin(m_model, global.modelFormat);
                        }
                        
                        if( string_char_at(line, string_length(line)) == " " ) {
                            line = string_copy(line, 1, string_length(line) - 1);
                        }
                        
                        var faces = string_split(string_delete(line, 1, 2), " ", false);
                        //show_debug_message(faces);
                        
                        var t_l = array_length_1d(faces);
                        var l = min(t_l, 3);
                        
                        var L  = ds_list_size(vertices);
                        var L1 = ds_list_size(texCoord);
                        var L2 = ds_list_size(normals );
                        
                        // Verices, Texture coordinates, Normals, Diffuse color, 
                        // Ambient color, Reflectivity color, Alpha, Tangent, 
                        // Bitangent / Binormal
                        for( var i = 0; i < l; i++ ) {
                            var f = string_split(faces[i], "/", true);
                            
                            // Vertex data
                            //if( vertices[| f[0] - 1] == undefined ) show_debug_message([vertices[| f[0] - 1], f[0] - 1, ds_list_size(vertices)]);
                            var v = vertices[| min(L - 1, f[0] - 1)], _x = v[0], _y = v[1], _z = v[2]; // Vertex
                            
                            // Model bounds
                            for( var k = 0; k < 3; k++ ) {
                                if( Bounds[k + 0] > v[k] ) { Bounds[k + 0] = v[k]; }
                                if( Bounds[k + 3] < v[k] ) { Bounds[k + 3] = v[k]; }
                            }
                            
                            if( f[1] != 0 ) var t = texCoord[| min(L1 - 1, f[1] - 1)], u = t[0], v = t[1]; // Texture
                            else var u = 0, v = 0, t = vec(0, 0);
                            
                            if( array_length_1d(f) > 2 ) var n = normals[| min(L2 - 1, f[2] - 1)], xn = n[0], yn = n[1], zn = n[2]; // Normals
                            else var xn = 0, yn = 0, zn = 0, n = vec(0, 0, 0); // Normals
                            
                            // Tangent
                            if( i + 2 < l ) {
                                // 
                                var f1 = string_split(faces[i + 1], "/", true);
                                var f2 = string_split(faces[i + 2], "/", true);
                                
                                // Next vertices
                                var v1 = vertices[| f1[0] - 1]; // Vertex
                                
                                if( is_array(v1) ) {
                                    if( f1[1] != 0 ) var t1 = texCoord[| f1[1] - 1]; // Texture
                                    else var t1 = vec(0, 0);
                                    
                                    // 
                                    var v2 = vertices[| f2[0] - 1]; // Vertex
                                    
                                    if( f2[1] != 0 ) var t2 = texCoord[| f2[1] - 1]; // Texture
                                    else var t2 = vec(0, 0);
                                    
                                    // Tangent
                                    var dp1 = vec(v1[0] - _x, v1[1] - _y, v1[2] - _z);
                                    var dp2 = vec(v2[0] - _x, v2[1] - _y, v2[2] - _z);
                                    var dt1 = vec(t1[0] -  u, t1[1] -  v);
                                    var dt2 = vec(t2[0] -  u, t2[1] -  v);
                                    
                                    var r = 1 / (dt1[0] * dt2[1] - dt1[1] * dt2[1]);
                                    var tangent = vec(r * (dp1[0] * dt2[1] - dp2[0] * dt1[1]), 
                                                      r * (dp1[1] * dt2[1] - dp2[1] * dt1[1]), 
                                                      r * (dp1[2] * dt2[1] - dp2[2] * dt1[1]));
                                    
                                    // Binormal
                                    var binormal = vec(r * (dp2[0] * dt1[0] - dp1[0] * dt2[0]), 
                                                       r * (dp2[1] * dt1[0] - dp1[1] * dt2[0]), 
                                                       r * (dp2[2] * dt1[0] - dp1[2] * dt2[0]));
                                    
                                    lastTangent  = tangent;
                                    lastBinormal = binormal;
                                }
                            } else {
                                var tangent  = lastTangent;
                                var binormal = lastBinormal;
                            }
                            
                            // 
                            vertex_position_3d(m_model, _x, _y, _z);                        // Vertex
                            vertex_texcoord(m_model, u, v);                                 // Texture
                            vertex_normal(m_model, xn, yn, zn);                             // Normal
                            vertex_colour(m_model, CurrentMaterial[0], 1);                  // Diffuse color
                            vertex_colour(m_model, CurrentMaterial[1], 1);                  // Ambient color
                            vertex_colour(m_model, CurrentMaterial[2], 1);                  // Reflectivity color
                            vertex_float2(m_model, CurrentMaterial[3], CurrentMaterial[4]); // Alpha
                            vertex_float3(m_model, tangent[0], tangent[1], tangent[2]);     // Tangent
                            vertex_float3(m_model, binormal[0], binormal[1], binormal[2]);  // Bitangent
                            
                            // 
                        }
                        
                        if( t_l > l ) { // 3, 2, 0
                            var tmp = [3, 2, 0];
                            for( var j = 0; j < 3; j++ ) {
                                var i = tmp[j];
                                var f = string_split(faces[i], "/", true);
                                
                                // Vertex data
                                var v = vertices[| f[0] - 1], _x = v[0], _y = v[1], _z = v[2]; // Vertex
                                
                                if( f[1] != 0 ) var t = texCoord[| f[1] - 1], u = t[0], v = t[1]; // Texture
                                else var u = 0, v = 0, t = vec(0, 0);
                                
                                if( array_length_1d(f) > 2 ) var n = normals[| f[2] - 1], xn = n[0], yn = n[1], zn = n[2]; // Normals
                                else var xn = 0, yn = 0, zn = 0, n = vec(0, 0, 0); // Normals
                                
                                // Tangent
                                if( i + 2 < l ) {
                                    // 
                                    var f1 = string_split(faces[i + 1], "/", true);
                                    var f2 = string_split(faces[i + 2], "/", true);
                                    
                                    // Next vertices
                                    var v1 = vertices[| f1[0] - 1]; // Vertex
                                    
                                    if( f1[1] != 0 ) var t1 = texCoord[| f1[1] - 1]; // Texture
                                    else var t1 = vec(0, 0);
                                    
                                    // 
                                    var v2 = vertices[| f2[0] - 1]; // Vertex
                                    
                                    if( f2[1] != 0 ) var t2 = texCoord[| f2[1] - 1]; // Texture
                                    else var t2 = vec(0, 0);
                                    
                                    // Tangent
                                    var dp1 = vec(v1[0] - _x, v1[1] - _y, v1[2] - _z);
                                    var dp2 = vec(v2[0] - _x, v2[1] - _y, v2[2] - _z);
                                    var dt1 = vec(t1[0] -  u, t1[1] -  v);
                                    var dt2 = vec(t2[0] -  u, t2[1] -  v);
                                    
                                    var r = 1 / (dt1[0] * dt2[1] - dt1[1] * dt2[1]);
                                    var tangent = vec(r * (dp1[0] * dt2[1] - dp2[0] * dt1[1]), 
                                                      r * (dp1[1] * dt2[1] - dp2[1] * dt1[1]), 
                                                      r * (dp1[2] * dt2[1] - dp2[2] * dt1[1]));
                                    
                                    // Binormal
                                    var binormal = vec(r * (dp2[0] * dt1[0] - dp1[0] * dt2[0]), 
                                                       r * (dp2[1] * dt1[0] - dp1[1] * dt2[0]), 
                                                       r * (dp2[2] * dt1[0] - dp1[2] * dt2[0]));
                                    
                                    lastTangent  = tangent;
                                    lastBinormal = binormal;
                                } else {
                                    var tangent  = lastTangent;
                                    var binormal = lastBinormal;
                                }
                                
                                // 
                                vertex_position_3d(m_model, _x, _y, _z);                        // Vertex
                                vertex_texcoord(m_model, u, v);                                 // Texture
                                vertex_normal(m_model, xn, yn, zn);                             // Normal
                                vertex_colour(m_model, CurrentMaterial[0], 1);                  // Diffuse color
                                vertex_colour(m_model, CurrentMaterial[1], 1);                  // Ambient color
                                vertex_colour(m_model, CurrentMaterial[2], 1);                  // Reflectivity color
                                vertex_float2(m_model, CurrentMaterial[3], CurrentMaterial[4]); // Alpha
                                vertex_float3(m_model, tangent[0], tangent[1], tangent[2]);     // Tangent
                                vertex_float3(m_model, binormal[0], binormal[1], binormal[2]);  // Bitangent
                            }
                        }
                        break;
                        
                    case "l ": // Line (v1 v2 ...)
                        if( string_char_at(line, string_length(line)) == " " ) {
                            line = string_copy(line, 1, string_length(line) - 1);
                        }
                        
                        var lines = string_split(string_delete(line, 1, 2), " ", false);
                        
                        // Verices
                        for( var i = 0; i < array_length_1d(lines); i++ ) {
                            var f = string_split(lines[i], "/", true);
                            
                            // Vertex data
                            var v = vertices[| f[0] - 1], _x = v[1], _y = v[2], _z = v[0]; // Vertex
                            
                            if( array_length_1d(f) > 1 && f[1] != 0 ) var t = texCoord[| f[1] - 1], u = t[0], v = t[1]; // Texture
                            else var u = 0, v = 0, t = vec(0, 0);
                            
                            if( array_length_1d(f) > 2 ) var n = normals [| f[2] - 1], xn = n[0], yn = n[1], zn = n[2]; // Normals
                            else var xn = 0, yn = 0, zn = 0, n = vec(0, 0, 0); // Normals
                            
                            // 
                            vertex_position_3d(m_model, _x, _y, _z);                        // Vertex
                            vertex_texcoord(m_model, u, v);                                 // Texture
                            vertex_normal(m_model, xn, yn, zn);                             // Normal
                            vertex_colour(m_model, CurrentMaterial[0], 1);                  // Diffuse color
                            vertex_colour(m_model, CurrentMaterial[1], 1);                  // Ambient color
                            vertex_colour(m_model, CurrentMaterial[2], 1);                  // Reflectivity color
                            vertex_float2(m_model, CurrentMaterial[3], CurrentMaterial[4]); // Alpha
                            vertex_float3(m_model, tangent[0], tangent[1], tangent[2]);     // Tangent
                            vertex_float3(m_model, binormal[0], binormal[1], binormal[2]);  // Bitangent
                            
                            // 
                            f = -1;
                            v = -1;
                        }
                        break;
                        
                    case "g ": // Group
                    case "o ":
                        //if( ds_list_size(models) > 10 ) { ____q = true; break; }                                                 // Debug
                        if( m_model > -1 ) {
                            ds_list_add(matMap, CurrentMaterial[5]);
                            ds_list_add(matMap, CurrentMaterial[6]);
                            ds_list_add(matMap, CurrentMaterial[7]);
                            ds_list_add(matMap, CurrentMaterial[8]);
                            ds_list_add(matMap, CurrentMaterial[9]);
                            
                            vertex_end(m_model);
                            
                            ds_list_add(models, m_model);
                            
                            show_debug_message(trace(0, CurrentMaterial[5], CurrentMaterial[6], CurrentMaterial[7], CurrentMaterial[8], CurrentMaterial[9]));
                            
                            // Clean up
                            /*ds_list_clear(vertices);
                            ds_list_clear(texCoord);
                            ds_list_clear(normals );*/
                        }
                        
                        m_model = vertex_create_buffer();
                        vertex_begin(m_model, global.modelFormat);
                        break;
                        
                    default: // Other
                        if( string_pos("mtllib ", line) > 0 ) {
                            // Material library
                            mtllib += string_delete(line, 1, string_length("mtllib "));
                            
                            if( filename_ext(mtllib) != ".mtl" ) mtllib += ".mtl";
                            if( !file_exists(mtllib) ) {
                                show_debug_message("Couldn't open .mtl file! " + mtllib);
                            } else {
                                m_mtl = LoadMaterialLibrary(mtllib);
                            }
                            
                            if( m_mtl != noone ) {
                                show_debug_message("MtlLib was loaded successfuly! " + mtllib);
                            }
                        } else if( string_pos("usemtl ", line) > 0 ) { // Use material
                            var m_name = string_delete(line, 1, string_length("usemtl "));
                            
                            if( m_mtl == noone ) {
                                // Load materials first!
                                show_debug_message("Load material lib first! " + m_name);
                            } else {
                                // Use material... Some how... Sort of...
                                if( CurrentMaterial == materialDefault ) {
                                    // If now we using default material
                                    CurrentMaterial = -1; // Delete them
                                }
                                
                                if( m_mtl[? m_name] == undefined ) {
                                    show_debug_message("Unknown material! " + m_name);
                                    CurrentMaterial = materialDefault;
                                } else {
                                    CurrentMaterial = m_mtl[? m_name];
                                    
                                    if( !is_array(CurrentMaterial) ) {
                                        // Use material... Some how... Sort of...
                                        CurrentMaterial = materialDefault;
                                    }
                                }
                            }
                        }
                        break;
                }
            }
        
    file_text_close(file);
    

// Unload material library
if( ds_exists(m_mtl, ds_type_map) ) {
    for( var i = ds_map_find_first(m_mtl); i != undefined; i = ds_map_find_next(m_mtl, i) ) {
        m_mtl[? i] = -1;
    }
    
    ds_map_destroy(m_mtl);
}

if( ds_list_find_index(models, m_model) == -1 ) {
    vertex_end(m_model);
    
    show_debug_message(CurrentMaterial[5]);
    show_debug_message(CurrentMaterial[6]);
    show_debug_message(CurrentMaterial[7]);
    show_debug_message(CurrentMaterial[8]);
    show_debug_message(CurrentMaterial[9]);
    ds_list_add(matMap, CurrentMaterial[5]);
    ds_list_add(matMap, CurrentMaterial[6]);
    ds_list_add(matMap, CurrentMaterial[7]);
    ds_list_add(matMap, CurrentMaterial[8]);
    ds_list_add(matMap, CurrentMaterial[9]);
    ds_list_add(models, m_model); // Add model to the list if it wan't there
}
#endregion
    
    // Cache model data
    var tf = file_text_open_write(fileNameCache);
        
        for( var i = 0; i < 6; i++ ) {
            file_text_write_real(tf, Bounds[i]);
            file_text_writeln(tf);
        }
        
        file_text_write_real(tf, ds_list_size(models)); // Write number of models
        file_text_writeln(tf);
        
        show_debug_message("------------------------------");
        
        for( var i = 0; i < ds_list_size(models); i++ ) {
            var m_model = models[| i];
            
            var buff = buffer_create_from_vertex_buffer(m_model, buffer_grow, 1);
            buffer_save(buff, "Cache\\" + filename_name(argument0) + "\\" + string(i) + ".vbuff"); // Save buffer
            //buffer_delete(buff); // Clean up
            MBUFF[i] = buff;
            
            vertex_freeze(m_model); // Store it in GPU
            
            for( var j = 0; j < 5; j++ ) {
                var a = matMap[| i * 5 + j]; // Write material map
                
                if( typeof(a) != "array" ) a = [-1, ""];
                show_debug_message(a);
                matMap[| i * 5 + j] = a[0];
                
                file_text_write_string(tf, a[1]);
                file_text_writeln(tf);
            }
        }
        
    file_text_close(tf);
    
    // Clean up
    ds_list_destroy(vertices);
    ds_list_destroy(texCoord);
    ds_list_destroy(normals );
    
    ds_list_destroy(ColVtxList);
    ds_stack_destroy(ColPosStack);
    
    CurrentMaterial = -1;
    materialDefault = -1;
    lastTangent     = -1;
} else {
    var __a__ = ["Diffuse", "Bump/Normal", "Mask", "Emission", "Metallic AO Rougness"];
    
    var tf = file_text_open_read(fileNameCache);
        
        for( var i = 0; i < 6; i++ ) {
            Bounds[i] = file_text_read_real(tf);
            file_text_readln(tf);
        }
        
        var count = file_text_read_real(tf);
        file_text_readln(tf);
        
        for( var i = 0; i < count; i++ ) {
            var fname = "Cache\\" + filename_name(argument0) + "\\" + string(i) + ".vbuff";
            
            if( file_exists(fname) ) { // Load model
                var buff = buffer_load(fname);
                var m_model = vertex_create_buffer_from_buffer(buff, global.modelFormat);
                vertex_freeze(m_model);
                //buffer_delete(buff);
                MBUFF[i] = buff;
                
                ds_list_add(models, m_model);
            } else {
                MBUFF[i] = -1;
                show_debug_message("Can't load buffer: " + fname);
            }
            
            // Load material maps
            for( var j = 0; j < 5; j++ ) {
                var tex = file_text_read_string(tf);
                file_text_readln(tf);
                
                if( tex != "" && file_exists(tex) ) {
                    ds_list_add(matMap, MaterialTextureLoad(tex)); // Load diffuse, normal, mask texture
                } else {
                    ds_list_add(matMap, "");
                    if( tex != "" ) show_debug_message("Can't load [" + __a__[j] + "] texture: " + tex);
                }
            }
        }
        
    file_text_close(tf);
}

global.MODEL_BUFFER[? argument0] = MBUFF;

show_debug_message(trace(argument0, "Bounds", Bounds[0], Bounds[1], Bounds[2], Bounds[3], Bounds[4], Bounds[5]));

// Generate bounds
var vbBounds = vertex_create_buffer();
vertex_begin(vbBounds, global.vfBounds);
    
    // Left
    vertex_position_3d(vbBounds, Bounds[0], Bounds[1], Bounds[2]); // Back-2-Forward Down
    vertex_position_3d(vbBounds, Bounds[3], Bounds[1], Bounds[2]);
    
    vertex_position_3d(vbBounds, Bounds[0], Bounds[4], Bounds[2]); // Back-2-Forward Up
    vertex_position_3d(vbBounds, Bounds[3], Bounds[4], Bounds[2]);
    
    vertex_position_3d(vbBounds, Bounds[0], Bounds[1], Bounds[2]); // Forward Up
    vertex_position_3d(vbBounds, Bounds[0], Bounds[4], Bounds[2]);
    
    vertex_position_3d(vbBounds, Bounds[3], Bounds[1], Bounds[2]); // Back Up
    vertex_position_3d(vbBounds, Bounds[3], Bounds[4], Bounds[2]);
    
    // Right
    vertex_position_3d(vbBounds, Bounds[0], Bounds[1], Bounds[5]); // Back-2-Forward Down
    vertex_position_3d(vbBounds, Bounds[3], Bounds[1], Bounds[5]);
    
    vertex_position_3d(vbBounds, Bounds[0], Bounds[4], Bounds[5]); // Back-2-Forward Up
    vertex_position_3d(vbBounds, Bounds[3], Bounds[4], Bounds[5]);
    
    vertex_position_3d(vbBounds, Bounds[0], Bounds[1], Bounds[5]); // Forward Up
    vertex_position_3d(vbBounds, Bounds[0], Bounds[4], Bounds[5]);
    
    vertex_position_3d(vbBounds, Bounds[3], Bounds[1], Bounds[5]); // Back Up
    vertex_position_3d(vbBounds, Bounds[3], Bounds[4], Bounds[5]);
    
    // Forward
    vertex_position_3d(vbBounds, Bounds[0], Bounds[4], Bounds[2]); // Forward Up
    vertex_position_3d(vbBounds, Bounds[0], Bounds[4], Bounds[5]);
    
    vertex_position_3d(vbBounds, Bounds[0], Bounds[1], Bounds[2]); // Forward Down
    vertex_position_3d(vbBounds, Bounds[0], Bounds[1], Bounds[5]);
    
    // Back
    vertex_position_3d(vbBounds, Bounds[3], Bounds[4], Bounds[2]); // Back Up
    vertex_position_3d(vbBounds, Bounds[3], Bounds[4], Bounds[5]);
    
    vertex_position_3d(vbBounds, Bounds[3], Bounds[1], Bounds[2]); // Back Down
    vertex_position_3d(vbBounds, Bounds[3], Bounds[1], Bounds[5]);
    
vertex_end(vbBounds);
vertex_freeze(vbBounds);

// 

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
var a = global.MODEL_BUFFER[? argument0];
for( var i = 0; i < array_length_1d(a); i++ ) buffer_delete(a[i]); // DELETE
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

global.m_bound [? argument0] = vbBounds;
global.m_bounds[? argument0] = Bounds;
global.m_map   [? argument0] = /*( ds_list_size(models) < 2 ) ? m_model : */[models, matMap];
show_debug_message("Model loaded in " + string(current_time - ct) + "(ms)");

return argument0;
