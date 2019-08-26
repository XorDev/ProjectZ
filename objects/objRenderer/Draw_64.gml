/// @desc Post processing / Debug
// Adaptation
// First pass

// 
/*for( var i = 1; i < HDRCycles; i++ ) {
    surface_set_target(i, );
}*/

#region DSSDO
if( uiGetValue(bvDSSDO) ) {
    gpu_set_blendenable(false);
    
    // SSDO Accumulation pass
    surface_set_target(rtSSDOAcc);
        
        draw_clear_alpha(0, 0);
        
        shader_set(shSSDOAccumulate);
            
            shader_set_uniform_f(_OcclusionMaxDistance           , uiGetValue(fvOccDist));
            shader_set_uniform_f(_OcclusionRadius                , uiGetValue(fvOccRad ));
            shader_set_uniform_f(_NoiseSize                      , 1024, 1024);
            shader_set_uniform_f(_InvResolution[shSSDOAccumulate], 1 / WIDTH, 1 / HEIGHT);
            
            shader_set_uniform_matrix_array(_mInvProj[shSSDOAccumulate], objCamera.mInvProj);
            shader_set_uniform_matrix_array(_mInvView[shSSDOAccumulate], matrix_inverse(objCamera.mView));
            
            texture_set_stage(1, surface_get_texture(rtDepth ));
            texture_set_stage(2, surface_get_texture(rtNormal));
            
            draw_sprite(LDR_RGBA_0, 0, 0, 0);
            
        shader_reset();
        
    surface_reset_target();
    
    // Blur
    // Horizontal
    surface_set_target(rtSSDOBlr);
        
        draw_clear_alpha(0, 0);
        
        shader_set(shSSDOAccumulationBlur);
            
            shader_set_uniform_f(_InvResolution[shSSDOAccumulationBlur], 1 / WIDTH, 1 / HEIGHT);
            shader_set_uniform_f(_Direction, 1, 0);
            
            texture_set_stage(1, surface_get_texture(rtNormal));
            
            draw_surface(rtSSDOAcc, 0, 0);
            
        shader_reset();
        
    surface_reset_target();
    
    // Vertical
    surface_set_target(rtSSDOBr2);
        
        draw_clear_alpha(0, 0);
        
        shader_set(shSSDOAccumulationBlur);
            
            shader_set_uniform_f(_InvResolution[shSSDOAccumulationBlur], 1 / WIDTH, 1 / HEIGHT);
            shader_set_uniform_f(_Direction, 0, 1);
            
            texture_set_stage(1, surface_get_texture(rtNormal));
            
            draw_surface(rtSSDOBlr, 0, 0);
            
        shader_reset();
        
    surface_reset_target();
    
    surface_set_target(rtSSDORes);
        
        draw_clear_alpha(0, 0);
        
        shader_set(shSSDOResolve);
            
            shader_set_uniform_f(_Time, current_time * .001);
            shader_set_uniform_f(_InvResolution[shSSDOResolve], 1 / WIDTH, 1 / HEIGHT);
            
            shader_set_uniform_matrix_array(_mInvProj[shSSDOAccumulate], objCamera.mInvProj);
            shader_set_uniform_matrix_array(_mInvView[shSSDOResolve], matrix_inverse(objCamera.mView));
            shader_set_uniform_matrix_array(_mViewProjInv           , matrix_inverse(matrix_multiply(objCamera.mView, objCamera.mProj)));
            
            if( gLightIndex > 0 ) {
                shader_set_uniform_f_array(_LightPos, gLightList_Pos);
                shader_set_uniform_f_array(_LightCol, gLightList_Col);
            }
            
            shader_set_uniform_f(_CameraPos[shSSDOResolve], objCamera.x, objCamera.y, objCamera.z);
            shader_set_uniform_f(_LightCount, gLightIndex);
            
            texture_set_stage(1, surface_get_texture(rtDepth ));
            texture_set_stage(2, surface_get_texture(rtNormal));
            
            draw_surface(rtSSDOBr2, 0, 0);
            
        shader_reset();
            
    surface_reset_target();
    
    gpu_set_blendenable(true);
}
#endregion

// HDR Pass
shader_set(shHDR);
    
    shader_set_uniform_f(_ACES, uiGetValue(bvACES));
    
    texture_set_stage(1, surface_get_texture(rtHDR1));
    
    draw_surface(rtHDR0, 0, 0);
    
shader_reset();

if( uiGetValue(bvSSGI) ) {
    shader_set(shSSGI);
        
        texture_set_stage(1, surface_get_texture(rtDepth));
        
        shader_set_uniform_f(_GIStrength, uiGetValue(GIStrength));
        shader_set_uniform_i(_GIMaxSteps, uiGetValue(GIMaxSteps));
        shader_set_uniform_f(_GIRayStep , uiGetValue(GIRayStep ));
        
        shader_set_uniform_f(_Far[shSSGI], objCamera.fFar);
        
        shader_set_uniform_matrix_array(_mInvProj[shSSGI], objCamera.mInvProj);
        shader_set_uniform_matrix_array(_mProj[shSSGI], objCamera.mProj);
        shader_set_uniform_matrix_array(_mView[shSSGI], objCamera.mView);
        
        draw_surface(rtNormal, 0, 0);
        
    shader_reset();
}

// Debug
gpu_set_blendenable(false);
//draw_surface_stretched(rtLight, WIDTH - 128, 0, 128, 128);
//draw_surface_stretched(rtNormal , WIDTH - 768, 0, 256, 128);
//draw_surface_stretched(rtSSDORes, WIDTH - 512, 0, 256, 128);
//draw_surface_stretched(rtHDR1, WIDTH - 256, 0, 256, 128);
if( surface_exists(vplTarget0[10]) ) draw_surface_stretched(vplTarget0[10], 0, 0, 1024, 256);
gpu_set_blendenable(true);

// Debug GUI
global.DEBUG ^= keyboard_check_pressed(vk_f3);
if( global.DEBUG ) {
    uiRenderBegin(0, 0, true);
        uiRender(ui);
    uiRenderEnd();
}

draw_set_color(c_white);
draw_set_halign(fa_middle);
draw_text(WIDTH * .5, 32, "FPS: "  + string(fps) + "; ms: " + string(delta_time * .001));

#region Editor
draw_set_halign(fa_right);

// Selection
if( global.MODE[eMode.Selection] ) {
    draw_text(WIDTH - 32, HEIGHT - 32, "Object selection");
    
    if( mouse_check_button_pressed(mb_left) ) {
        var mx = window_mouse_get_x();
        var my = window_mouse_get_y();
        
        // Get selected Object ID
        buffer_get_surface(sDebugBuffer, rtHDR0, buffer_surface_copy, 0, 0);
        var data = buffer_peek(sDebugBuffer, 3 + 4 * (mx + my * WIDTH), buffer_u8);
        
        Selection = data;
        show_debug_message("Selected: " + string(data));
    }
}

// Transform
if( global.MODE[eMode.Transform] ) {
    if( Selection > 0 ) {
        draw_text(WIDTH - 32, HEIGHT - 32, "Object transform");
        
        if( mouse_check_button_pressed(mb_left) ) {
            var mx = device_mouse_x_to_gui(0);
            var my = device_mouse_y_to_gui(0);
            
            //if( Mode == move ) 
            {
                // Get world pos
                buffer_get_surface(sDebugBuffer, rtDepth, buffer_surface_copy, 0, 0);
                var R = buffer_peek(sDebugBuffer, 0 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
                var G = buffer_peek(sDebugBuffer, 1 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
                var B = buffer_peek(sDebugBuffer, 2 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
                
                var Depth = (R * 4096. + G * 16. + B * .0625);
                
                var v;
                with( objCamera ) { v = ScreenToWorld(mView, [mx, my, Depth]); }
                
                TargetTransform = v;
                Transformed = false;
                TransformFlags = eTransformFlags.Position;
            }
        }
        
        // Move object around
        var Q = keyboard_check(ord("Q"));
        var E = keyboard_check(ord("E"));
        var W = keyboard_check(ord("W"));
        var A = keyboard_check(ord("A"));
        var S = keyboard_check(ord("S"));
        var D = keyboard_check(ord("D"));
        
        if( Q || E || W || A || S || D ) {
            TargetTransform = [W - S, A - D, Q - E];
            TransformFlags = eTransformFlags.Relative | eTransformFlags.Position;
            Transformed = false;
        }
    } else {
        draw_text(WIDTH - 32, HEIGHT - 32, "Select object");
    }
}

// Placing
if( global.MODE[eMode.Placing] ) {
    draw_text(WIDTH - 32, HEIGHT - 32, "Object placing");
    
    if( mouse_check_button_pressed(mb_left) ) {
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);
        
        // Get world pos
        buffer_get_surface(sDebugBuffer, rtDepth, buffer_surface_copy, 0, 0);
        var R = buffer_peek(sDebugBuffer, 0 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
        var G = buffer_peek(sDebugBuffer, 1 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
        var B = buffer_peek(sDebugBuffer, 2 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
        
        var Depth = (R * 4096. + G * 16. + B * .0625);
        
        var v;
        with( objCamera ) { v = ScreenToWorld(mView, [mx, my, Depth]); }
        
        PlaceModel(modelScifiCrate, [0, 0, 0], [100, 100, 100], v);
        
        gUpdateCollisions     = true;
        gUpdateCollisionsData = [ModelLastIndex - 1];
        gUpdateCollisionsF    = .1;
    }
}

// Drawing
if( global.MODE[eMode.Drawing] ) {
    var chn = ["red", "green", "blue"];
    draw_text(WIDTH - 48, HEIGHT - 48, "Drawing in " + chn[gChannelIndex] + " channel\nBrush size " + string(gBrushSize));
    
    var data = ModelList[mAxisID];
    var flags = eRenderFlags.Axis | eRenderFlags.DontShow | eRenderFlags.NoDepth | eRenderFlags.ZWDisable;
    if( mouse_check_button(mb_left) ) {
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);
        
        // Get world pos
        buffer_get_surface(sDebugBuffer, rtDepth, buffer_surface_copy, 0, 0);
        var R = buffer_peek(sDebugBuffer, 0 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
        var G = buffer_peek(sDebugBuffer, 1 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
        var B = buffer_peek(sDebugBuffer, 2 + 4 * (mx + my * WIDTH), buffer_u8) / 255;
        
        // 
        var Depth = (R * 4096. + G * 16. + B * .0625);
        
        var v;
        with( objCamera ) { v = ScreenToWorld(mView, [mx, my, Depth - 20]); }
        
        data[@ eModelItem.Position] = v;
        flags = eRenderFlags.Axis | eRenderFlags.NoDepth | eRenderFlags.ZWDisable;
        
        // Get selection id
        buffer_get_surface(sDebugBuffer, rtHDR0, buffer_surface_copy, 0, 0);
        var A = buffer_peek(sDebugBuffer, 3 + 4 * (mx + my * WIDTH), buffer_u8);
        
        draw_text(WIDTH - 192, HEIGHT - 64, A);
        var index = ds_list_find_index(gPatchList, A);
        if( index <= -1 ) {
            
        } else {
            var p = gPatchList[| index + 1];
            draw_text(WIDTH - 192, HEIGHT - 32, "Grid[# " + trace(p[0], p[1]) + "];");
        }
    }
    
    data[@ eModelItem.Flags] = flags;
} else {
    var data = ModelList[mAxisID];
    data[@ eModelItem.Flags] = eRenderFlags.Axis | eRenderFlags.DontShow | eRenderFlags.NoDepth | eRenderFlags.ZWDisable;
}

draw_set_halign(fa_left);
#endregion

if( gUpdateCollisions ) {
    draw_set_color(c_red);
    draw_rectangle(WIDTH * .5 - 64, HEIGHT - 48, WIDTH * .5 + 128 * (gUpdateCollisionsF - .5), HEIGHT - 24, 0);
    
    draw_set_color(c_black);
    draw_rectangle(WIDTH * .5 - 64, HEIGHT - 48, WIDTH * .5 + 64                             , HEIGHT - 24, 1);
}
