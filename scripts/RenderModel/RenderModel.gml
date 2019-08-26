/// @arg model
var model = ModelGet( argument0 );
if( model > -1 ) {
    var OI = ObjectIndex;
    var v = shader_current();
    if( shader_current() == -1 ) {
        if( pass & eRenderFlags.Opaque ) {
            if( pass & eRenderFlags.Depth ) {
                shader_set(shRenderModelDepth);
                v = shader_current();
            } else {
                if( pass & eRenderFlags.Terrain ) {
                    shader_set(shTerrainSplat);
                } else if( pass & eRenderFlags.Axis ) {
                    shader_set(shRenderModelAxis);
                } else {
                    shader_set(shRenderModel);
                }
                
                v = shader_current();
            }
        }
    }
    
    // Uniforms
    if( v != -1 ) {
        shader_set_uniform_f(_Far[v], objCamera.fFar);
        
        if( (pass & eRenderFlags.Depth == 0) ) {
            // Light matrix
            var mLightMatrix = objLightDirectional.mLightSpace; //matrix_multiply(objLightDirectional.mView, objLightDirectional.mProj);
            shader_set_uniform_matrix_array(_LightMatrix[v], mLightMatrix);
            
            // Camera position
            shader_set_uniform_f(_CameraPos[v], objCamera.x, objCamera.y, objCamera.z);
            
            // Sun direction
            var n = [objLightDirectional.x, objLightDirectional.y, objLightDirectional.z];
            var l = point_distance_3d(0, 0, 0, n[0], n[1], n[2]);
            shader_set_uniform_f(_SunDir[v], n[0] / l, n[1] / l, n[2] / l);
            
            shader_set_uniform_f(_ShadowMapSize [v], objLightDirectional.w, objLightDirectional.h);
            shader_set_uniform_f(_ShadowMapTexel[v], 1. / objLightDirectional.w, 1. / objLightDirectional.h);
            
            // Colors
            //if( uiGetValue(bvColors) ) {
            //    // Sky color
            //    var col = uiColor(uiGetValue(csSky));
            //    shader_set_uniform_f(_SkyColor[v], col[0] / 255, col[1] / 255, col[2] / 255);
            //    
            //    // Fog color
            //    col = uiColor(uiGetValue(csFog));
            //    shader_set_uniform_f(_FogColor[v], col[0] / 255, col[1] / 255, col[2] / 255);
            //    
            //    //_SunColor
            //}
            
            // Selection
            if( global.MODE[eMode.Selection] ) {
                shader_set_uniform_f(_Selected [v], Selection == ObjectIndex);
                shader_set_uniform_f(_Selection[v], ObjectIndex * (1 / 255));
                //show_debug_message(ObjectIndex * (1 / 255));
            }
            
            // Settings
            shader_set_uniform_f(_CelShading  [v], uiGetValue(bvCelShading ));
            shader_set_uniform_f(_Tonemapping [v], uiGetValue(bvTonemapping));
            shader_set_uniform_f(_Fog         [v], uiGetValue(bvFog        ));
            shader_set_uniform_f(_FogHeight   [v], uiGetValue(bvFogHeight  ));
            shader_set_uniform_f(_FogDistant  [v], uiGetValue(bvFogDistant ));
            shader_set_uniform_f(_RimLight    [v], uiGetValue(bvRimLight   ));
            shader_set_uniform_f(_Shadows     [v], uiGetValue(bvShadows    ));
            
            shader_set_uniform_f(_HFogFalloff [v], uiGetValue(fvFogFalloff ));
            shader_set_uniform_f(_HFogHeight  [v], uiGetValue(fvFogHeight  ));
            shader_set_uniform_f(_HFogNear    [v], uiGetValue(fvFogNear    ));
            
            shader_set_uniform_f(_DFogStart   [v], uiGetValue(fvFogStart   ));
            shader_set_uniform_f(_FogDensity  [v], uiGetValue(fvFogDensity ));
            
            shader_set_uniform_f(_Exposure    [v], uiGetValue(fvExposure   ));
            
            shader_set_uniform_f(_CSSteps     [v],      uiGetValue(fvCSSteps));
            shader_set_uniform_f(_CSStepsInv  [v], 1. / uiGetValue(fvCSSteps));
            
            shader_set_uniform_f(_RLLowBound  [v], uiGetValue(fvRLLowBound));
            
            // 
            texture_set_stage(1, surface_get_texture(rtLight));
            texture_set_stage(2, sprite_get_texture(sprNoiseRG_256, -1));
            
            gpu_set_texfilter_ext(1, false);
            gpu_set_texfilter_ext(2, false);
            gpu_set_tex_filter_ext(1, false);
            gpu_set_tex_filter_ext(2, false);
            //gpu_set_tex_repeat_ext(1, false);
        }
    }
    
    // Render sub models
    if( typeof(model) == "array" ) {
        var list = model[0];
        var mat  = model[1];
        
        for( var i = 0; i < ds_list_size(list); i++ ) {
            var diff = -1, bump = -1, mask = -1, emms = -1, maor = -1;
            
            if( pass & eRenderFlags.Depth == 0 ) {
                if( pass & eRenderFlags.Terrain == 0 ) {
                    // Regular model
                    var a = mat[| i * 5 + 0]; // Diffuse
                    var b = mat[| i * 5 + 1]; // Normal
                    var c = mat[| i * 5 + 2]; // Mask
                    var d = mat[| i * 5 + 3]; // Emission
                    var e = mat[| i * 5 + 4]; // Metallic AO Roughness
                    
                    if( is_array(a) ) { diff = (a[0] ? surface_get_texture(a[1]) : sprite_get_texture(a[1], -1)); }
                    if( is_array(b) ) { bump = (b[0] ? surface_get_texture(b[1]) : sprite_get_texture(b[1], -1)); }
                    if( is_array(c) ) { mask = (c[0] ? surface_get_texture(c[1]) : sprite_get_texture(c[1], -1)); }
                    if( is_array(d) ) { emms = (d[0] ? surface_get_texture(d[1]) : sprite_get_texture(d[1], -1)); }
                    if( is_array(e) ) { maor = (e[0] ? surface_get_texture(e[1]) : sprite_get_texture(e[1], -1)); }
                    
                    //if( argument0 == modelScifiCrate ) show_debug_message([i, a, diff, maor]);
                    
                    /*texture_set_stage(_BumpSampl, bump);
                    shader_set_uniform_f(_BumpExists, bump > -1);
                    
                    texture_set_stage(_MaskSampl, mask);
                    shader_set_uniform_f(_HasMask, mask > -1);*/
                    
                    if( emms == -1 ) emms = sprite_get_texture(sprBlack, -1);
                    
                    texture_set_stage(3, emms);
                    shader_set_uniform_f(_Emission[v], (emms != -1));
                    
                    if( diff == -1 ) diff = sprite_get_texture(sprDefaultTexture, -1);
                } else {
                    // Terrain
                    var t = EXT0[0];
                    
                    texture_set_stage(3, sprite_get_texture(sprBlack, -1));
                    
                    texture_set_stage(4, sprite_get_texture(t[0], -1));
                    texture_set_stage(5, sprite_get_texture(t[1], -1));
                    texture_set_stage(6, sprite_get_texture(t[2], -1));
                    texture_set_stage(7, surface_get_texture(t[3]));
                }
            }
            
            vertex_submit(list[| i], global.modelRendering, diff);
        }
        
        ObjectIndex++;
    } else { // Render single model
        vertex_submit(model, global.modelRendering, -1);
        ObjectIndex++;
    }
    
    if( shader_current() == v ) {
        shader_reset();
        
        if( (pass & eRenderFlags.Depth == 0) && global.m_bound[? argument0] != undefined ) {
            if( Selection == OI ) {
                shader_set(shBounds);
                    
                    vertex_submit(global.m_bound[? argument0], pr_linelist, -1);
                    
                shader_reset();
            }
        }
    }
}
