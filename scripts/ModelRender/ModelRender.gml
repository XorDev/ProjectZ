/// @desc ModelRender(model);
/// @arg model
// Render model
//show_debug_message([global.m_map[? global.m_list[| argument[0]]], argument0]);
/*var model = ModelGet( argument0 );

if( model > -1 ) {
    if( shader_current() == -1 ) shader_set(shGBufferDefault);
    
    shader_set_uniform_f(objControl._Far2, ZFAR);
    
    if( typeof(model) == "array" ) { // Render models
        var list = model[0];
        var mat = model[1];
        
        var _Diffuse = 0;
        
        for( var i = 0; i < ds_list_size(list); i++ ) {
            //if( mat[| i] > -1 ) texture_set_stage(_Diffuse, sprite_get_texture(mat[i], -1));
            var t = -1;
            if( mat[| i] > -1 ) {
                t = sprite_get_texture(mat[| i], -1);
            }
            
            vertex_submit(list[| i], global.modelRendering, t);
        }
    } else { // Render single model
        vertex_submit(model, global.modelRendering, -1);
    }
    
    if( shader_current() == shGBufferDefault ) shader_reset();
}

d3d_transform_set_identity();
*/
