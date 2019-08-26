/// @arg [x]
/// @arg [y]
/// @arg UICreationTrace
var q = argument_count == 1;
var UICT = q ? argument[0] : argument[2];
var _x = q ? 0 : argument[0];
var _y = q ? 0 : argument[1];

matrix_add_translate(_x, _y, 0);
var nullVertex = matrix_nullvertex();

var scheme   = __uiSchemeID;
var text     = scheme[? uiScheme.Text];
var inactive = scheme[? uiScheme.Inactive];

var __size__ = ds_list_size(UICT);

for( var i = 0; i < __size__; i++ ) {
    var data = UICT[| i];
    var GIID = ((UICT + 1) << 21) + ((i + 1) << 7);
    
    if( uiFlag(__uiOrientation, uiFlags.NewLine) ) {
        var v = matrix_nullvertex();
        if( v[0] + 32 >= __uiMAX_WIDTH + __uiX ) {
            v[1] = 32 * ((v[0] + 32) mod (__uiMAX_WIDTH));
            v[0] = (v[0] + 32) - (__uiMAX_WIDTH);
            
            show_debug_message((v[0] + 32) mod (__uiMAX_WIDTH));
            matrix_set(matrix_world, matrix_build_identity());
            matrix_add_translate(v[0], v[1], 0);
        }
    }
    
    switch( data[0] ) {
        case uiType.PANEL:
#region
            __uiX = data[4];
            __uiY = data[5];
            __uiOrientation = data[6];
            
            matrix_add_translate(__uiX, __uiY, 0);
            
            __uiMAX_WIDTH = data[2];
            __uiMAX_HEIGHT = data[3] - 16;
            
            var h = data[1] == "" ? 0 : string_height_ext(data[1], -1, __uiMAX_WIDTH - 2);
            __uiHeaderH = h;
            
            // Panel header
            var in = matrix_rect(0, 0, data[2], h);
            var q = in && mouse_check_button(mb_left) && !uiFlag(data[6], uiFlags.Inactive);
            
            var back = scheme[? uiScheme.Background];
            var header = scheme[? uiScheme.Header];
            var clickIn = scheme[? uiScheme.InHeaderC];
            
            if( h > 0 ) {
                draw_set_color(inactive * uiFlag(data[6], uiFlags.Inactive) + make_color_rgb(header[0] + clickIn * q, header[1] + clickIn * q, header[2] + clickIn * q));
                draw_rectangle(0, 0, data[2], h, 0);
            }
            
            // Panel background
            draw_set_color(inactive * uiFlag(data[6], uiFlags.Inactive) + make_color_rgb(back[0], back[1], back[2]));
            draw_rectangle(0, h, data[2], h + data[3], 0);
            
            // Reset color
            draw_set_color(inactive * uiFlag(data[6], uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text_ext(2, 0, data[1], -1, __uiMAX_WIDTH - 2); // Header text
            
            var v = matrix_nullvertex();
            
            uiRender(0, h, data[7]); // Render
            
            var v2 = matrix_nullvertex();
            var diff = [v2[0] - v[0], v2[1] - v[1]];
            
            // Rectangles
            var list = uiRectangles[? UICT]; if( list == undefined || !ds_exists(list, ds_type_list) ) { list = ds_list_create(); uiRectangles[? UICT] = list; }
            var a = [__uiX + _x, __uiY + _y, __uiMAX_WIDTH, __uiMAX_HEIGHT + diff[1] + h]; a[@ 2] += a[0]; a[@ 3] += a[1];
            list[| i] = a;
            
            matrix_add_translate(-__uiX, -__uiY, 0);
            var offset = matrix_nullvertex();
            matrix_add_translate(-offset[0], -(offset[1]), 0);
            
            // Drag panel around
            if( h > 0 && uiFlag(data[6], uiFlags.NonFixed) ) {
                if( in && mouse_check_button_pressed(mb_left) && !__uiMove && !uiFlag(data[6], uiFlags.Inactive) ) {
                    // Move init
                    __uiMove = true;
                    __uiMoveID = UICT;
                    __uiMoveP = [__uiMX - __uiX, __uiMY - __uiY];
                    __uiMoveData = data;
                }
            
                if( __uiMove && __uiMoveID == UICT ) __uiIN = in;
            }
#endregion
            break;
            
        case uiType.GROUP:
#region
            var w, h;
            w = __uiX + __uiMAX_WIDTH - nullVertex[0];
            h = max(sprite_get_height(sprUIGroup), string_height_ext(data[1], -1, w));
            
            var in = matrix_rect(0, 0, w, h);
            var q = in && mouse_check_button(mb_left);
            
            var clickIn = scheme[? uiScheme.ClickIn];
            var gpBack  = scheme[? uiScheme.GroupBack];
            var In      = scheme[? uiScheme.In];
            
            draw_set_color(inactive * uiFlag(data[3], uiFlags.Inactive) + make_color_rgb(gpBack[0] + In * data[2] + clickIn * q, gpBack[1] + In * data[2] + clickIn * q, gpBack[2] + In * data[2] + clickIn * q));
            draw_rectangle(0, 0, w, h, 0);
            
            draw_set_color(inactive * uiFlag(data[3], uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text_ext(sprite_get_width(sprUIGroup), 0, data[1], -1, w);
            
            draw_sprite(sprUIGroup, data[2], 0, 0);
            
            data[@ 2] ^= mouse_check_button_released(mb_left) && in && __uiClickZ == nullVertex[2];
            if( data[2] ) {
                __uiMAX_WIDTH -= 16 * 1;
                uiRender(16, h, data[4]);
                matrix_add_translate(-16, 0, 0); // -16, cause it was only for group
                __uiMAX_WIDTH += 16 * 1;
                
                // Bottom side
                draw_set_color(inactive * uiFlag(data[3], uiFlags.Inactive) + make_color_rgb(gpBack[0], gpBack[1], gpBack[2]));
                draw_rectangle(0, 0, w, 12, 0);
                draw_set_color(inactive * uiFlag(data[3], uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            }
            
            matrix_add_translate(0, !data[2] * h + 12, 0);
#endregion
            break;
            
        case uiType.TEXT:
#region
            var flags = data[2];
            var ext0  = data[3];
            
            if( ext0 == noone ) {
                data[@ 3] = [1, 100, noone];
                ext0 = data[3];
            }
            
            var w = __uiX + __uiMAX_WIDTH - nullVertex[0] - 2;
            var h = string_height_ext(data[1], -1, w);
            
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            if( uiFlag(flags, uiFlags.Button) ) {             // Button
                var In      = scheme[? uiScheme.In];
                var clickIn = scheme[? uiScheme.ClickIn];
                
                var in = matrix_rect(2, 2, w, h);
                var q = in && mouse_check_button(mb_left);
                
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0] + In * in + clickIn * q, text[1] + In * in + clickIn * q, text[2] + In * in + clickIn * q));
                
                if( in && mouse_check_button_released(mb_left) ) {
                    if( script_exists(ext0[2]) ) script_execute(ext0[2]);
                }
            }
            
            var v = matrix_nullvertex();
            if( uiFlag(flags, uiFlags.TextScroll) ) {     // Text scroll
                var back = scheme[? uiScheme.ScrollBack];
                var scroll = scheme[? uiScheme.Scroll];
                var In      = scheme[? uiScheme.In];
                var clickIn = scheme[? uiScheme.ClickIn];
                
                var in = matrix_rect(2, 2, w, h);
                var q = in && mouse_check_button(mb_left);
                
                //h = ext0[1];
                
                var maxCount = h div string_height("C") + 3;
                var maxDraw = ext0[1] div string_height("C") + 2;
                var step = (ext0[1] / (maxCount - maxDraw));
                
                if( maxCount >= maxDraw ) {
                    var prev = draw_get_color();
                    
                    // Scroll back
                    draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(back[0], back[1], back[2]));
                    draw_line_width(w - 8, 0, w - 8, ext0[1] - 2 - 4, 2);
                    
                    // Scroll
                    draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(scroll[0] + In * in + clickIn * q, scroll[1] + In * in + clickIn * q, scroll[2] + In * in + clickIn * q));
                    
                    if( uiFlag(flags, uiFlags.RoundRect) ) {
                        draw_roundrect(w - 8 - 3, step * (ext0[0] - 1) + 4, w - 8 + 4, step * ext0[0] - 4 - 2 - 2, 0);
                    } else {
                        draw_rectangle(w - 8 - 3, step * (ext0[0] - 1) + 4, w - 8 + 4, step * ext0[0] - 4 - 2 - 2, 0);
                    }
                    
                    if( __uiClickZ == nullVertex[2] ) {
                        for( var j = 1; j <= maxCount - maxDraw; j++ ) {
                            if( matrix_rect(w - 16, step * (j - 1), w, step * j) ) {
                                if( mouse_check_button(mb_left) ) {
                                    ext0[@ 0] = j;
                                }
                            }
                        }
                    }
                    
                    if( matrix_rect(w - 16, 0, w, ext0[1] - 2) && !uiFlag(flags, uiFlags.Inactive) && __uiClickZ == nullVertex[2] ) {       // Move position
                        var sbID = (UICT << 10) + (i << 3);
                        if( mouse_check_button_pressed(mb_left) ) {
                            __uiSBID = sbID;
                        }
                        
                        if( mouse_check_button(mb_left) && (__uiSBID == sbID) ) {
                            ext0[@ 0] = (__uiMY - v[1] + step * .5) / step;
                        }
                        
                        if( mouse_check_button_released(mb_left) ) __uiSBID = -1;
                    }
                    
                    ext0[@ 0] = clamp(ext0[0], 1, maxCount - maxDraw);
                    matrix_add_translate(0, -(ext0[0] - 1) * string_height("C"), 0);
                    uiClipBegin(__uiX, __uiY + __uiHeaderH, w, ext0[1]);   // Clip begin
                    
                    //array_set(UICT[| i], 3, [ext0[0], ext0[1], ext0[2]]);
                    data[@ 3] = [ext0[0], ext0[1], ext0[2]];
                    //show_debug_message(data);
                    
                    draw_set_color(prev);
                    
                    h = ext0[1];
                }
            }
            
            draw_text_ext(2, 2, data[1], -1, w);    // Draw text
            matrix_add_translate(0, 2 * 2 + h, 0);
            
            if( uiFlag(flags, uiFlags.TextScroll) ) { // Clip end
                matrix_add_translate(0, (ext0[0] - 1) * string_height("C"), 0);
                uiClipEnd();
            }
#endregion
            break;
            
        case uiType.SPRITE:
#region
            
            var flags = data[3];
            var ext0  = data[4];
            
            var w = sprite_get_width(data[1]);
            var h = sprite_get_height(data[1]);
            
            // Button flag exists
            if( uiFlag(flags, uiFlags.Button) ) {
                var in = matrix_rect(0, 0, w, h);
                var q = in && mouse_check_button(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(flags, uiFlags.Inactive);
                
                var clickIn = scheme[? uiScheme.ClickIn];
                var gpBack  = scheme[? uiScheme.ButtonBack];
                var In      = scheme[? uiScheme.In];
                
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(gpBack[0] + In * in + clickIn * q, gpBack[1] + In * in + clickIn * q, gpBack[2] + In * in + clickIn * q));
                if( uiFlag(flags, uiFlags.RoundRect) ) {    // Round rectangle button
                    draw_roundrect(2, 2, w, h, 0);
                } else {
                    draw_rectangle(2, 2, w, h, 0);          // Rectangle button
                }
                
                if( in && mouse_check_button_released(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(flags, uiFlags.Inactive) ) {
                    if( script_exists(ext0) ) script_execute(ext0);show_debug_message(script_get_name(ext0));
                }
            }
            
            if( uiFlag(__uiOrientation, uiFlags.Ver) ) {
                /*switch(  ) {
                    case uiFillType.NONE: draw_sprite(data[1], data[2], 2, 2); break;
                    case uiFillType.CUT :  break;
                
                }*/
                draw_sprite(data[1], data[2], 2, 2);
                
                matrix_add_translate(0, 2 * 2 + h, 0);
            } else if( uiFlag(__uiOrientation, uiFlags.Hor) ) {
                /*switch(  ) {
                    case uiFillType.NONE: draw_sprite(data[1], data[2], 2, 2); break;
                    case uiFillType.CUT :  break;
                
                }*/
                
                draw_sprite(data[1], data[2], 2, 2);
                
                matrix_add_translate(2 * 2 + w, 0, 0);
            }
#endregion
            break;
            
        case uiType.FLOAT:
        case uiType.INT:
#region
            var FLOAT_TYPE = (data[0] == uiType.FLOAT);
            var flags = data[5];
            var W = __uiX + (__uiMAX_WIDTH - nullVertex[0]);
            var w = W / 2 - 2 - 14;
            var w2 = w - (__uiX * .5 - 2);
            var h = string_height_ext(string(data[1]), -1, w2);
            var callback = data[6];
            
            var back = scheme[? uiScheme.SliderBack];
            var slider = scheme[? uiScheme.Slider];
            var inSlider = scheme[? uiScheme.InSlider];
            
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text_ext(2, 0, string(data[1]), -1, w2); // Text
            
            var in = matrix_rect(w, 2, W - 8, 2 + 16);
            var q = in && mouse_check_button(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(flags, uiFlags.Inactive);
            
            // Slider background
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(back[0] + inSlider * q, back[1] + inSlider * q, back[2] + inSlider * q));
            draw_rectangle(2 + w - 4, 2, W - 8, 2 + 16, 0);
            
            var width = (W - (2 + w + 8));
            var globalOffset = [(nullVertex[0] + 2 + w + __uiX * 0)];
            var Offset = [(2 + w)];
            var rate = (abs(data[3]) + abs(data[4]) + 1);
            var rate2 = rate / width;
            
            if( !__uiMove && in && __uiClickZ == nullVertex[2] && !uiFlag(flags, uiFlags.Inactive) ) {
                if( mouse_check_button(mb_left) ) {
                    var px = (__uiMX - globalOffset[0]) / width;
                    data[@ 2] = FLOAT_TYPE ? px : (floor(px / rate2) * rate2);
                    
                    if( script_exists(callback) ) { // Callback function
                        script_execute(callback, 
                            string(data[1]), lerp(data[3], data[4], data[2]), data[2], 
                            mouse_check_button_pressed(mb_left), flags);
                    }
                }
                
                if( uiFlag(flags, uiFlags.Reset) && mouse_check_button_released(mb_left) ) {
                    data[@ 2] = .5 * abs(data[3] / data[4]);
                    
                    if( !FLOAT_TYPE ) data[@ 2] = floor(data[2] / rate2) * rate2;
                }
                
                data[@ 2] = clamp(data[@ 2], 0, 1);
            }
            
            var v = (data[2] * width);// : (floor(lerp(0, width, data[2]) / rate) * rate);
            
            // Slider
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(slider[0] + inSlider * in, slider[1] + inSlider * in, slider[2] + inSlider * in));
            draw_rectangle(Offset[0] + v - 4, 2, Offset[0] + v, 2 + 16, 0);
            
            v = lerp(data[3], data[4], data[2]);
            
            // Draw value
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_set_halign(fa_center);
            draw_text(2 + w + width / 2, 2, FLOAT_TYPE ? v : floor(v));
            draw_set_halign(fa_left);
            
            matrix_add_translate(0, 2 * 2 + h, 0);
#endregion
            break;
            
        case uiType.SCROLL:
#region
            // 
            var flags = data[1];
            var type = [(uiFlag(flags, uiFlags.Hor)), (uiFlag(flags, uiFlags.Ver))];
            var w = (__uiMAX_WIDTH  - nullVertex[0]);
            var h = (__uiMAX_HEIGHT - nullVertex[1]);
            var width  = (data[2] == -1) ? w : data[2];
            var height = (data[3] == -1) ? h : data[3];
            var ext0 = data[4];
            if( ext0 == noone ) {
                data[@ 4] = [2, 2];
                ext0 = data[4];
            }
            
            __uiMAX_WIDTH  -= type[1] * (16 + 2);
            __uiMAX_HEIGHT -= type[0] * (16 + 2);
            
            var v = matrix_nullvertex();
            
            // 
            var f1 = max(0, (uiFlag(flags, uiFlags.Top)) - (uiFlag(flags, uiFlags.Bottom))); // Side
                                                                                             // 0 - Top
                                                                                             // 1 - Bottom
            
            var f2 = max(0, (uiFlag(flags, uiFlags.Right)) - (uiFlag(flags, uiFlags.Left))); // Side
                                                                                             // 0 - Left
                                                                                             // 1 - Right
            
            //if( data[@ 6] ) 
                matrix_add_translate(16*0 - (ext0[1] - 2) * 32, 16 - (ext0[0] - 2) * 32, 0);
            uiClipBegin(__uiX + nullVertex[0] + 0*16 * type[0], v[1] + 16, width, height - 16 * (1 + 0*type[0] + f1));  // Clip begin
                
                uiRender(0, 0, data[5]);
                
            uiClipEnd();                                                                                            // Clip end
            //if( data[@ 6] ) 
                matrix_add_translate((ext0[1] - 2) * 32 - 16*0, (ext0[0] - 2) * 32 - 16, 0);
            
            __uiMAX_WIDTH  += type[1] * (16 + 2);
            __uiMAX_HEIGHT += type[0] * (16 + 2);
            
            // 
            var vert = matrix_nullvertex();
            var diff = [vert[0] - nullVertex[0], vert[1] - (v[1] + 16)];
            
            // Render scrollbars
            if( type[1] ) {                                                                                 // Vertical
                matrix_set(matrix_world, matrix_build_identity());
                matrix_add_translate(16*0, v[1], 0);
                var v = matrix_nullvertex();
                
                data[@ 6] = false;
                if( diff[1] > 0 ) {
                    
                    var maxCount = diff[1] div 28;
                    var maxDraw = height div 28;
                    var step = (height / (maxCount - maxDraw));
                    
                    // Draw gradient
                    /*draw_sprite_stretched(sprUIScrollGradient, 0, 0, 0, w - 16, 32);
                    draw_sprite_part_ext(sprUIScrollGradient, 0, 0, 0, 1, 32, 0, height - 32, w - 16, 1, -1, 1);*/
                    
                    // Draw
                    if( maxCount >= maxDraw ) {
                        data[@ 6] = true;
                        var back = scheme[? uiScheme.ScrollBack];
                        var sel  = scheme[? uiScheme.Scroll];
                        
                        // Scroll back
                        draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(back[0], back[1], back[2]));
                        draw_line_width(w - 8, 4, w - 8, height - 2 - 4, 2);
                        
                        // Scroll
                        draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_colour_rgb(sel[0], sel[1], sel[2]));
                        
                        if( uiFlag(flags, uiFlags.RoundRect) ) {
                            draw_roundrect(w - 8 - 3, step * (ext0[0] - 1) + 2, w - 8 + 4, step * ext0[0] - 4, 0);
                        } else {
                            draw_rectangle(w - 8 - 3, step * (ext0[0] - 1) + 2, w - 8 + 4, step * ext0[0] - 4, 0);
                        }
                    }
                    
                    if( !uiFlag(flags, uiFlags.Inactive) ) {
                        if( matrix_rect(w - 16, 4, w, height) && __uiClickZ == nullVertex[2] ) {       // Move position
                            var sbID = (UICT << 10) + (i << 3);
                            if( mouse_check_button_pressed(mb_left) ) {
                                __uiSBID = sbID;
                            }
                            
                            if( mouse_check_button(mb_left) && (__uiSBID == sbID) ) {
                                ext0[@ 0] = (__uiMY - v[1] + step * .5) / step;
                            }
                            
                            if( mouse_check_button_released(mb_left) ) __uiSBID = -1;
                        }
                        
                        if( matrix_rect(0, 0, w, height) ) {
                            var _D = mouse_wheel_down() - mouse_wheel_up();
                            
                            ext0[@ 0] += _D;
                        }
                    }
                    
                    ext0[@ 0] = clamp(ext0[0], 2, maxCount - maxDraw);
                }
            }
            
            if( type[0] ) {                                                                                 // Horizontal
                matrix_set(matrix_world, matrix_build_identity());
                matrix_add_translate(0, height, 0);
                
                if( diff[0] > 0 ) {
                    var maxCount = diff[0] div 32;
                    var maxDraw = width div 32;
                    var step = (width / (maxCount - maxDraw));
                    
                    // Draw
                    if( maxCount >= maxDraw ) {
                        var back = scheme[? uiScheme.ScrollBack];
                        var sel  = scheme[? uiScheme.Scroll];
                        
                        // Draw scrollbar back
                        draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_colour_rgb(back[0], back[1], back[2]));
                        draw_rectangle(0, -16, w - 16 * type[1], 0, 0);
                        
                        // Draw lil' thing
                        draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_colour_rgb(sel[0], sel[1], sel[2]));
                        draw_rectangle(2, (ext0[1] - 1) * step + 2 - 16, w - 2, ext0[1] * step - 2, 0);
                    }
                    
                    // Mouse is down and IN_ rectangle
                    if( mouse_check_button(mb_left) && __uiClickZ == nullVertex[2] && matrix_rect(0, -16, w - 16 * type[1], 0) && !uiFlag(flags, uiFlags.Inactive) ) {
                        for( var j = 1; j <= maxCount - maxDraw; j++ ) {
                            if( matrix_rect(2, (ext0[1] - 1) * step + 2 - 16, w - 2, ext0[1] * step - 2) ) {
                                if( mouse_check_button(mb_left) ) {
                                    ext0[@ 1] = j;
                                }
                            }
                        }
                        
                        ext0[@ 1] = clamp(ext0[1], 2, maxCount - 1);
                    }
                }
            }
            
            matrix_set(matrix_world, matrix_build_identity());
            matrix_add_translate(16*0, v[1] + height, 0);
            //matrix_add_translate(0, height, 0);
#endregion
            break;
            
        case uiType.TAB:
#region
            // Tab header
            if( uiFlag(__uiTSFlags, uiFlags.Hor) ) {                                                                               // Horizontal tabs
                var w = (__uiMAX_WIDTH - 2) / __uiTSSize;
                var h = string_height_ext(data[1], -1, w);
                
                matrix_add_translate(w * i, -h, 0);
                
                var in = matrix_rect(0, 0, w, h);
                var q = in && mouse_check_button_pressed(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(__uiTSFlags, uiFlags.Inactive);
                
                var header = scheme[? uiScheme.TabBack];
                var clickIn = scheme[? uiScheme.InHeaderC];
                var In = scheme[? uiScheme.In];
                
                var F = (i == __uiTSID);
                
                // 
                if( q ) {
                    __uiTSID = i;
                }
                
                // Tab header
                draw_set_color(inactive * uiFlag(__uiTSFlags, uiFlags.Inactive) + make_color_rgb(header[0] + clickIn * q + In * F, header[1] + clickIn * q + In * F, header[2] + clickIn * q + In * F));
                draw_rectangle(0, 0, w, h, 0);
                
                draw_set_color(inactive * uiFlag(__uiTSFlags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
                draw_text_ext(2, 0, data[1], -1, w); // Header text
                matrix_add_translate(-w * i, h + 2, 0);
                
                var v = matrix_nullvertex();
                if( F ) {
                    __uiHeaderH += h;
                    
                    // Render tab content
                    uiRender(0, 0, data[2]);
                    
                    //__uiHeaderH -= h;
                }
                
                var diff = matrix_nullvertex();
                matrix_add_translate( - (v[0] - nullVertex[0]), -(diff[1] - nullVertex[1]), 0);
                
                var v = matrix_nullvertex();
                if( v[0] > nullVertex[0] + w ) {
                    matrix_add_translate(-(v[0] - (nullVertex[0] + w)), 0, 0);
                    show_debug_message(-(v[0] - (nullVertex[0] + w)));
                }
            } else if( uiFlag(__uiTSFlags, uiFlags.Ver) ) {                                                                        // Vertical tabs
                var h = (__uiMAX_HEIGHT - 2 - __uiHeaderH + (__uiHeaderH == 0 ? 16 : 0)) / __uiTSSize;
                var w = string_height_ext(data[1], -1, h);
                
                var f = max(0, (uiFlag(__uiTSFlags, uiFlags.Right)) - (uiFlag(__uiTSFlags, uiFlags.Left))); // Side
                                                                                                            // 0 - Left
                                                                                                            // 1 - Right
                
                var _x = (__uiMAX_WIDTH - w - 2) * f;
                matrix_add_translate(_x, h * i + __uiHeaderH, 0);
                
                var in = matrix_rect(0, 0, w, h);
                var q = in && mouse_check_button_pressed(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(__uiTSFlags, uiFlags.Inactive);
                
                var header = scheme[? uiScheme.TabBack];
                var clickIn = scheme[? uiScheme.InHeaderC];
                var In = scheme[? uiScheme.In];
                
                var F = (i == __uiTSID);
                
                // 
                if( q ) {
                    __uiTSID = i;
                }
                
                // Tab header
                draw_set_color(inactive * uiFlag(__uiTSFlags, uiFlags.Inactive) + make_color_rgb(header[0] + clickIn * q + In * F, header[1] + clickIn * q + In * F, header[2] + clickIn * q + In * F));
                draw_rectangle(0, 0, w, h, 0);
                
                draw_set_color(inactive * uiFlag(__uiTSFlags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
                draw_text_ext_transformed(w + 2, 0, data[1], -1, h, 1, 1, 270); // Header text
                matrix_add_translate((!f) ? w : (-_x), -h * i - __uiHeaderH, 0);
                
                if( F ) {
                    __uiHeaderH += h;
                    __uiMAX_WIDTH -= w + 8;
                    
                    // Render tab content
                    uiRender(0, 16, data[2]);
                    
                    __uiMAX_WIDTH += w + 8;
                    __uiHeaderH -= h;
                }
                
                var diff = matrix_nullvertex();
                matrix_add_translate(-(diff[0] - nullVertex[0]), -(diff[1] - nullVertex[1]), 0);
            }
#endregion
            break;
            
        case uiType.TABSPACE:
#region
            var back = scheme[? uiScheme.Background];
            
            var flags = data[2];
            
            // Backup data
            var tmp__uiTSFlags = -1;
            var tmp__uiTSID = -1;
            var tmp__uiTSSize = -1;
            
            if( __uiTSFlags > -1 ) tmp__uiTSFlags = __uiTSFlags;
            if( __uiTSID    > -1 ) tmp__uiTSID = __uiTSID;
            if( __uiTSSize  > -1 ) tmp__uiTSSize = __uiTSSize;
            
            // 
            __uiTSFlags = flags;
            if( uiFlag(flags, uiFlags.Hor) ) {
                // Tab space header
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(back[0], back[1], back[2]));
                draw_rectangle(0, 0, __uiMAX_WIDTH, 16, 0);
                
                var list = data[3];
                __uiTSSize = ds_list_size(list);
                __uiTSID = data[1];
                
                if( __uiTSID >= 0 && __uiTSID < __uiTSSize ) {
                    // Render tabs
                    //__uiHeaderH += string_height("C");
                        
                        uiRender(0, 0, list);
                        
                    //__uiHeaderH -= string_height("C");
                    
                    data[@ 1] = __uiTSID; // Set new tab opened
                } else data[@ 1] = clamp(__uiTSID, 0, __uiTSSize - 1); // Clamp value a bit
            } else if( uiFlag(flags, uiFlags.Ver) ) {
                // Tab space header
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(back[0], back[1], back[2]));
                draw_rectangle(0, 0, 16, __uiMAX_HEIGHT, 0);
                
                var list = data[3];
                __uiTSSize = ds_list_size(list);
                __uiTSID = data[1];
                
                if( __uiTSID >= 0 && __uiTSID < __uiTSSize ) {
                    // Render tab
                    uiRender(0, 0, list); // Render tab
                    
                    //__uiMAX_WIDTH -= 16 + 8;
                    data[@ 1] = __uiTSID; // Set new tab opened
                } else data[@ 1] = clamp(__uiTSID, 0, __uiTSSize - 1); // Clamp value a bit
            }
            
            __uiTSFlags = tmp__uiTSFlags;
            __uiTSID = tmp__uiTSID;
            __uiTSSize = tmp__uiTSSize;
#endregion
            break;
            
        case uiType.TREEVIEW:
#region
            var flags = data[4];
            __uiTVCallback = false;
            __uiTVFlags = flags;
            
            var W = (__uiMAX_WIDTH - 4);
            var w = W / (uiFlag(flags, uiFlags.Full) ? 1 : 2);
            var h = data[1] == "" ? 0 : string_height_ext(data[1], -1, w);
            
            var _x = !uiFlag(flags, uiFlags.Full) * (W - w) / 2;
            matrix_add_translate(_x + 2, 2, 0);
            
            var height = uiFlag(flags, uiFlags.Squared) ? (w - h) : (__uiMAX_HEIGHT - h);
            
            // Panel header
            var in = matrix_rect(0, 0, w, h);
            var q = in && mouse_check_button(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(flags, uiFlags.Inactive);
            
            var back = scheme[? uiScheme.TreeViewBack];
            var header = scheme[? uiScheme.Header];
            var clickIn = scheme[? uiScheme.InHeaderC];
            
            if( h > 0 ) {
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(header[0] + clickIn * q, header[1] + clickIn * q, header[2] + clickIn * q));
                draw_rectangle(0, 0, w, h, 0);
            }
            
            // View tree background
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(back[0], back[1], back[2]));
            draw_rectangle(0, h, w, h + height, 0);
            
            // Title
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text_ext(2, 2, data[1], -1, w);
            
            // Render items
            var list = data[2];
            var tsize = data[6];
            
            __uiTVSprite = data[3];
            var ei = uiFlag(flags, uiFlags.Sprite);
            var sw = sprite_get_width (ei ? __uiTVSprite[0] : __uiTVSprite);  // Sprite size
            var sh = sprite_get_height(ei ? __uiTVSprite[0] : __uiTVSprite);
            
            __uiTV_sw = sw;
            __uiTV_sh = sh;
            
            var maxCount = (tsize * sh / 1.25) div 32 + 1;   // Content size
            var maxDraw = height div 32 - 0;                // Max drawen items
            var step = (height / (maxCount - maxDraw));     // Step for scroll thing
            
            // Scrollbar
            var ext0 = data[5];
            if( ext0 == noone ) { // Update
                data[@ 5] = [0, 0];
                ext0 = data[5];
            }
            
            matrix_add_translate(0, h, 0);
            var v = matrix_nullvertex();
            if( uiFlag(flags, uiFlags.Scrollbar) && maxCount >= maxDraw ) {
                var back    = scheme[? uiScheme.ScrollBack];
                var scroll  = scheme[? uiScheme.Scroll];
                var In      = scheme[? uiScheme.In];
                var clickIn = scheme[? uiScheme.ClickIn];
                
                /*/ Scroll back
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(back[0], back[1], back[2]));
                draw_rectangle(w - 16, 0, w, height - 1, 0);
                
                // Scroll
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(scroll[0] + In * in + clickIn * q, scroll[1] + In * in + clickIn * q, scroll[2] + In * in + clickIn * q));
                draw_rectangle(w - 16 + 2, step * (ext0[0] - 1) + 2, w - 2, step * ext0[0] - 2, 0);*/
                
                // Scroll back
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(back[0], back[1], back[2]));
                draw_line_width(w - 8, 0, w - 8, height - 2, 2);
                
                // Scroll
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(scroll[0] + In * in + clickIn * q, scroll[1] + In * in + clickIn * q, scroll[2] + In * in + clickIn * q));
                
                if( uiFlag(flags, uiFlags.RoundRect) ) {
                    draw_roundrect(w - 8 - 3, step * (ext0[0] - 1) + 2, w - 8 + 4, step * ext0[0] - 4, 0);
                } else {
                    draw_rectangle(w - 8 - 3, step * (ext0[0] - 1) + 2, w - 8 + 4, step * ext0[0] - 4, 0);
                }
                
                /*for( var j = 1; j <= maxCount - maxDraw; j++ ) {
                    if( matrix_rect(w - 16, step * (j - 1), w, step * j) ) {
                        if( mouse_check_button(mb_left) ) {
                            ext0[@ 0] = j;
                        }
                    }
                }*/
                
                if( matrix_rect(w - 16, 0, w, height) && !uiFlag(flags, uiFlags.Inactive) && __uiClickZ == nullVertex[2] ) {       // Move position
                    var sbID = (UICT << 10) + (i << 3);
                    if( mouse_check_button_pressed(mb_left) ) {
                        __uiSBID = sbID;
                    }
                    
                    if( mouse_check_button(mb_left) && (__uiSBID == sbID) ) {
                        ext0[@ 0] = (__uiMY - v[1] + step * .5) / step;
                    }
                    
                    if( mouse_check_button_released(mb_left) ) __uiSBID = -1;
                }
                
                ext0[@ 0] = clamp(ext0[0], 1, maxCount - maxDraw);
                matrix_set(matrix_world, matrix_build_identity());
                matrix_add_translate(0, -(ext0[0] - 1) * (sh / 1.25), 0);
            } else {
                matrix_set(matrix_world, matrix_build_identity());
            }
            
            matrix_add_translate(v[0] + 2 - _x, 2 + v[1] - 4, 0); // Offsets
            
            __uiTVSize = 0;
            __uiTVFlags = flags;
            __uiTVSelected = ext0[1];
            uiClipBegin(__uiX + _x + 2, v[1], w, height);   // Clip begin
                
                uiRender(0, 0, list);
                matrix_add_translate(-(2 - _x), -(2 + h), 0);
                
            uiClipEnd();                            // End clip
            var _v = matrix_nullvertex();
            
            // 
            matrix_set(matrix_world, matrix_build_identity());
            matrix_add_translate(v[0], v[1] + height, 0);
            
            // Draw gradient
            if( uiFlag(flags, uiFlags.Gradient) ) {
                var a = scheme[? uiScheme.GradientAlpha];
                draw_sprite_stretched_ext(sprUIScrollGradient, 0, 0, -height, w + 1, 32, -1, a); // Top
                draw_sprite_part_ext(sprUIScrollGradient, 0, 0, 0, 1, 32, 0, 4, w + 1, -1, -1, a); // Bottom
            }
            
            ext0[@ 1] = __uiTVSelected;
            
            if( __uiTVCallback ) if( script_exists(data[7]) ) script_execute(data[7]); // Callback
            
            // Scrollbar
            if( uiFlag(flags, uiFlags.Scrollbar) && maxCount >= maxDraw ) {
            //    matrix_add_translate(0, (ext0[0] - 1) * (sh / 1.25), 0);
            }
#endregion
            break;
            
        case uiType.TITEM:
#region
            var _W = __uiMAX_WIDTH - 16 * (1 + uiFlag(__uiTVFlags, uiFlags.Scrollbar)) - 8;
            var ei = uiFlag(__uiTVFlags, uiFlags.Sprite); // Extra icons
            var _inactive_ = uiFlag(__uiTVFlags, uiFlags.Inactive);
            
            if( ei ) {
                var l = array_length_1d(data);
                var flags = data[l - 2];
                var arr = data[l - 1];
            }
            
            // Item selected
            if( uiFlag(__uiTVFlags, uiFlags.Selectable) ) {
                if( uiFlag(__uiTVSelected, (1 << __uiTVSize)) ) {
                    draw_set_color(inactive * _inactive_ + scheme[? uiScheme.TreeViewItemSel]);
                    draw_rectangle(16 - 6, 6 - 4, _W, __uiTV_sh - 6 + 4, 0);
                }
            }
            
            var in = matrix_rect(16 - 6, 6, _W, __uiTV_sh - 6);
            var q = in && mouse_check_button(mb_left) && __uiClickZ == nullVertex[2];
            if( in && mouse_check_button_released(mb_left) && __uiClickZ == nullVertex[2] && !_inactive_ ) {
                __uiTVSelected = keyboard_check(vk_control) 
                                    ? (uiFlag(__uiTVSelected, 1 << __uiTVSize)           // Is selected
                                              ? (__uiTVSelected & ~(1 << __uiTVSize))    // Clear bit
                                              : __uiTVSelected | (1 << __uiTVSize))      // Set bit
                                    : (1 << __uiTVSize);                                 // No cntrl -> Set index to pow(2, i)
            }
            
            // 
            if( in && mouse_check_button_released(mb_left) && __uiClickZ == nullVertex[2] && !_inactive_ ) {
                __uiTVCallback = true;
            }
           
            // Call drag event
            if( uiFlag(__uiTVFlags, uiFlags.Draggable) ) {
                if( in && mouse_check_button_pressed(mb_left) && __uiClickZ == nullVertex[2] && !_inactive_ ) {
                    if( abs(SV_MouseDeltaX) > 0 || abs(SV_MouseDeltaY) > 0 ) {
                        __uiDragItem = uiPack(data, noone);
                        __uiDragWidth = _W;
                    }
                    
                    //show_debug_message([SV_MouseDeltaX, SV_MouseDeltaY]);
                }
            }
            
            // Draw sprite
            var s = ei ? __uiTVSprite[0] : __uiTVSprite;
            if( s > -1 ) draw_sprite(s, data[2], 2, 2);
            
            // Extra sprites
            if( ei ) {
                s = __uiTVSprite[1];
                for( var z = 0; z < array_length_1d(arr); z++ ) {
                    var flag = array_get(arr[z], 1);
                    draw_sprite(s, z * 2 + uiFlag(flags, flag), _W - z * 12 + 2 - 24, 2);
                    
                    // [uiType.TITEM, "Skybox", 1, 0, uiFlags.Null, [[true, uiFlags.Inactive]]], 
                    if( mouse_check_button_released(mb_left) && matrix_rect(_W - z * 12 + 2 - 24, 2, _W - z * 12 + 2 - 24 + 30, 2 + 30) ) {
                        // Toggle bit
                        data[@ l - 2] = (uiFlag(flags, flag) ? (flags & ~flag) : (flags | flag));
                        
                        show_debug_message([flags, data[l - 2]]);
                        
                        array_set(arr[z], 0, !uiFlag(flags, flag)); // Set state
                    }
                }
            }
            
            draw_set_color(inactive * _inactive_ + make_color_rgb(text[0], text[1], text[2]));
            draw_text(2 + __uiTV_sw, 6, data[1]);                       // Title
            
            // Outline
            if( uiFlag(__uiTVFlags, uiFlags.TOutline) ) {
                draw_set_color(inactive * _inactive_ + scheme[? uiScheme.TreeViewOutL]);
                
                matrix_add_translate(16, 16, 0);
                
                draw_primitive_begin(pr_linelist); // Using primitives, cause
                                                   // In prev. step(see uiType.TREEVIEW)
                                                   // We have enabled clipping shader.
                                                   // Due to rendering system of DX and 
                                                   // OpenGL, we should use something 
                                                   // That can replace draw_line for 
                                                   // Example draw_primitive_begin()
                                                   // With draw_vertex() for drawing lines 
                                                   // And draw_primitive_end() and the end
                                                   // Also we want to draw a lines so we 
                                                   // Use pr_linelist for it...
                    // root
                    // 
                    // --- item <--
                    draw_vertex(-16, 2); draw_vertex(2 - 8, 2);
                    
                    if( i < __size__ - 1 ) {
                        // root
                        // 
                        // --- item
                        // | <--
                        draw_vertex(-16, 2); draw_vertex(-16, __uiTV_sh / 1.25);
                    }
                    
                    // root
                    // | <--
                    // --- item
                    // | 
                    draw_vertex(-16, -__uiTV_sh / 2); draw_vertex(-16, 2);
                    
                draw_primitive_end();
                
                matrix_add_translate(-16, -16, 0);
            }
            
            __uiTVSize++;
            matrix_add_translate(0, 2 + __uiTV_sh / 1.25, 0);
#endregion
            break;
            
        case uiType.TFOLDER:
#region
            var _W = __uiMAX_WIDTH - 16 * (1 + uiFlag(__uiTVFlags, uiFlags.Scrollbar)) - 8;
            var ei = uiFlag(__uiTVFlags, uiFlags.Sprite); // Extra icons
            var _inactive_ = uiFlag(__uiTVFlags, uiFlags.Inactive);
            
            if( ei ) {
                var s = __uiTVSprite[1];
                var l = array_length_1d(data);
                var flags = data[l - 2];
                var arr = data[l - 1];
            }
            
            // Arrow
            draw_sprite(sprUITreeviewIcons, data[5], 2, 2);
            
            // Extra sprites
            if( ei ) {
                for( var z = 0; z < array_length_1d(arr); z++ ) {
                    var flag = array_get(arr[z], 1);
                    draw_sprite(s, z * 2 + uiFlag(flags, flag), _W - z * 12 + 2 - 8, 2);
                    
                    // [uiType.TITEM, "Skybox", 1, 0, uiFlags.Null, [[true, uiFlags.Inactive]]], 
                    if( mouse_check_button_released(mb_left) && matrix_rect(_W - z * 12 + 2 - 8, 2, _W - z * 12 + 2 - 8 + 30, 2 + 30) ) {
                        // Toggle bit
                        data[@ l - 2] = (uiFlag(flags, flag) ? (flags & ~flag) : (flags | flag));
                        
                        array_set(arr[z], 0, !uiFlag(flags, flag)); // Set state
                    }
                }
            }
            
            // Title
            draw_set_color(inactive * _inactive_ + make_color_rgb(text[0], text[1], text[2]));
            draw_text(2 + 16, 2, data[1]);
            
            // Toggle
            data[@ 5] ^= ( mouse_check_button_released(mb_left) && matrix_rect(2, 2, 2 + 16 + string_width(data[1]), 2 + 16)
                       && __uiClickZ == nullVertex[2] && !_inactive_ );
            
            // Render items
            if( data[5] ) {
                uiRender(16, 2 + 16, data[4]);
                matrix_add_translate(-16, -(2 + 16), 0);
            }
            
            matrix_add_translate(0, 16, 0);
#endregion
            break;
            
        case uiType.BUTTON:
#region
            var w, h;
            w = (__uiX + __uiMAX_WIDTH - nullVertex[0] - 16 - 8);
            h = string_height_ext(data[1], -1, w) + 16;
            
            var flags = data[3];
            var in = matrix_rect(8, 8, w + 8, h + 8);
            var q = in && mouse_check_button(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(flags, uiFlags.Inactive);
            
            var clickIn = scheme[? uiScheme.ClickIn];
            var gpBack  = scheme[? uiScheme.ButtonBack];
            var In      = scheme[? uiScheme.In];
            
            // Background
            var q0 = inactive * uiFlag(flags, uiFlags.Inactive);
            draw_set_color(make_color_rgb(gpBack[0] + In * data[2] + clickIn * q + q0, gpBack[1] + In * data[2] + clickIn * q + q0, gpBack[2] + In * data[2] + clickIn * q + q0));
            
            if( uiFlag(flags, uiFlags.RoundRect) ) {
                draw_roundrect(8, 8, w + 8, h + 8, 0);
            } else {
                draw_rectangle(8, 8, w + 8, h + 8, 0);
            }
            
            var index = ds_list_find_index(__uiFancyQueue, GIID);
            uiFancyStuffDraw(8, w, h, index, flags);
            
            // Title
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
                
                draw_text_ext(8 + w / 2, 8 + h / 2, data[1], -1, w);
                
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            
            if( in && mouse_check_button_released(mb_left) ) {
                uiFancyStuffEnqueue(flags, GIID);
                if( script_exists(data[2]) ) script_execute(data[2]);
            }
            
            matrix_add_translate(0, h + 16, 0);
#endregion
            break;
            
        case uiType.RADIOBUTTONSPACE:
#region
            var w = __uiX + __uiMAX_WIDTH - nullVertex[0] - 2;
            var h = string_height_ext(data[1], -1, w);
            
            // Title
            draw_set_color(inactive * uiFlag(data[4], uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text_ext(2, 2, data[1], -1, w);
            
            __uiRBFlags = data[4];
            __uiRBCID = data[3];
            uiRender(8, h + 8, data[5]);
            
            if( data[3] != __uiRBCID ) {
                data[@ 3] = __uiRBCID; // Update
                
                // Call callback function
                if( script_exists(data[2]) ) script_execute(data[2]);
            }
            
            matrix_add_translate(-8, -8, 0);
#endregion
            break;
            
        case uiType.RADIOBUTTON:
#region
            var header = scheme[? uiScheme.RadioButton];
            var w = __uiX + __uiMAX_WIDTH - nullVertex[0];
            var h = string_height_ext(data[1], -1, w);
            
            draw_set_color(inactive * uiFlag(__uiRBFlags, uiFlags.Inactive) + make_color_rgb(header[0], header[1], header[2]));
            var v = !(__uiRBCID == i);
            
            if( uiFlag(__uiRBFlags, uiFlags.Squared) ) {
                draw_rectangle(2 - 8, h / 2 - 8, 4 + 8, h / 2 + 8, v);
            } else if( uiFlag(__uiRBFlags, uiFlags.RoundRect) ) {
                draw_roundrect(2 - 8, h / 2 - 8, 4 + 8, h / 2 + 8, v);
            } else {
                draw_circle(4, h / 2 + 2, 8, v);
            }
            
            // Title
            draw_set_color(inactive * uiFlag(__uiRBFlags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text_ext(2 + 4 + 8, h / 2 + 2 - 8, data[1], -1, w);
            
            var in = matrix_circle(4, h / 2 + 2, 8) || matrix_rect(16 - 2, 2, 16 + w, 16 + h);
            var q = in && mouse_check_button(mb_left) && !uiFlag(__uiRBFlags, uiFlags.Inactive);
            
            if( in && mouse_check_button_released(mb_left) && !uiFlag(__uiRBFlags, uiFlags.Inactive) ) {
                __uiRBCID = i;
                if( script_exists(data[2]) ) script_execute(data[2]);
            }
            
            matrix_add_translate(0, h + 8, 0);
#endregion
            break;
            
        case uiType.COLORSELECTOR:
#region
            var clickIn = scheme[? uiScheme.ClickIn];
            var gpBack  = scheme[? uiScheme.CSBack];
            var In      = scheme[? uiScheme.In];
            var Radius  = scheme[? uiScheme.CSRad];
            
            var flags = data[2];
            var ext0 = data[3];
            if( ext0 == noone ) {
                data[@ 3] = [[0, 0], 0, [0, 0]];
                ext0 = data[3];
            }
            
            var h = 224;
            var CX = (__uiMAX_WIDTH - 2 * 2) / 2;
            var CY = (h - 2 * 2 - 32) / 2;
            
            // Background
            draw_set_color(gpBack);
            draw_rectangle(2, 2, __uiMAX_WIDTH - 2, h - 2, 0);
            
            // Title
            draw_set_color(make_color_rgb(text[0], text[1], text[2]));
            draw_set_halign(fa_center); draw_text(CX, 4, data[1]); draw_set_halign(fa_left);
            
            // Color wheel
            if( uiFlag(flags, uiFlags.CSCircle) ) {
                // Circle mask
                shader_set(shColorWheel);
                    
                    shader_set_uniform_f(_cwType, 1);
                    
                    uiCircle(CX, CY, Radius);
                    
                shader_reset();
            } else {
                // Rectangle mask
                shader_set(shColorWheel);
                    
                    shader_set_uniform_f(_cwType, 0);
                    
                    draw_primitive_begin(pr_trianglefan);
                        
                        draw_vertex_texture(CX - Radius, CY - Radius, 0, 0); // Top left
                        draw_vertex_texture(CX + Radius, CY - Radius, 1, 0); // Top right
                        draw_vertex_texture(CX + Radius, CY + Radius, 1, 1); // Bottom right
                        draw_vertex_texture(CX - Radius, CY + Radius, 0, 1); // Bottom left
                        
                        //draw_rectangle(128 - Radius, 128 - Radius, 128 + Radius, 128 + Radius, 0);
                        
                    draw_primitive_end();
                    
                shader_reset();
            }
            
            // Draw points
            if( uiFlag(flags, uiFlags.CSCircle) ) {
                var count = 0;
                for( var j = 0; j < 4; j++ ) {
                    if( !uiFlag(flags, 1 << (log2(uiFlags.CSPoint1) + j)) ) { break; } // End loop, no more points
                    count++;
                }
                
                var col = uiTriangulateColor(ext0[1], count, Radius - 8);
                
                if( count > 2 ) draw_primitive_begin(pr_trianglefan);
                
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + scheme[? uiScheme.CSSel]);
                var angle = 360 / count;
                for( var j = 0; j < count; j++ ) {
                    draw_circle(CX + lengthdir_x(Radius - 8, angle * j + ext0[1]), CY + lengthdir_y(Radius - 8, angle * j + ext0[1]), 8, 1);
                    if( count > 2 ) draw_vertex_color(CX + lengthdir_x(Radius - 8 * 2, angle * j + ext0[1]), CY + lengthdir_y(Radius - 8 * 2, angle * j + ext0[1]), col, 1);
                }
                
                if( count > 2 ) {
                    draw_primitive_end();
                }
                
                // Otherwise 
                matrix_add_translate(0, CY + 64 + 4, 0);
                
                // 
                draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + col);
                draw_rectangle(CX - (CX - 4 - 8) / 2 - 32, 4, CX + (CX - 4 - 8) / 2 + 32, 32, 0);
                
                matrix_add_translate(0, -(CX + 64 + 4), 0);
                
                if( mouse_check_button(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(flags, uiFlags.Inactive) ) {                                      // Drag points around
                    if( matrix_circle(CX, CY, Radius + 8) ) {
                        var v = matrix_nullvertex();
                        var a = point_direction(v[0] + CX, v[1] + CY, __uiMX, __uiMY);
                        
                        ext0[@ 1] = a;
                    }
                }
            } else {
                var point = ext0[0];
                if( mouse_check_button(mb_left) && __uiClickZ == nullVertex[2] && !uiFlag(flags, uiFlags.Inactive) ) {                                      // Drag point around
                    if( matrix_rect(128 - Radius, 128 - Radius, 128 + Radius, 128 + Radius) ) {
                        var v = matrix_nullvertex();
                        
                        point[@ 0] = __uiMX - v[0] - 8;
                        point[@ 1] = __uiMY - v[1] - 8;
                    }
                }
                
                point[@ 0] = clamp(point[0], CX - Radius, CY + Radius - 4);
                point[@ 1] = clamp(point[1], CX - Radius, CY + Radius - 4);
                
                draw_circle(point[0] + 8, point[1] + 8, 8, 1);
            }
            
            matrix_add_translate(0, h + 16, 0);
#endregion
            break;
            
        case uiType.FELLOUTLIST:
#region
            // 
            var h = string_height(data[1]);
            var in = matrix_rect(2, 2, __uiMAX_WIDTH - 2, h - 1);
            var q = in * mouse_check_button_released(mb_left) && !uiFlag(flags, uiFlags.Inactive);
            var list = data[7];
            var size = ds_list_size(list);
            var flags = data[4];
            var item = data[2];
            var idata = list[| item];
            var ext0 = data[5];
            var iext0 = idata[2];
            if( ext0 == noone ) {
                data[@ 5] = [-1];
                ext0 = data[5];
            }
            
            __uiFLFlags = flags;
            __uiFLEXT0 = ext0;
            
            var side = (uiFlag(flags, uiFlags.Right) - uiFlag(flags, uiFlags.Left));
            if( side == 0 ) side = 1;
            
            // Background
            var clickIn = scheme[? uiScheme.ClickIn];
            var gpBack  = scheme[? uiScheme.FLBack];
            var In      = scheme[? uiScheme.In];
            
            var f = 16 * (side == -1);
            matrix_add_translate(f, 0, 0);
            __uiMAX_WIDTH -= f;
            
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(gpBack[0] + In * in + clickIn * q, gpBack[1] + In * in + clickIn * q, gpBack[2] + In * in + clickIn * q));
            draw_rectangle(2, 2, __uiMAX_WIDTH - 2, h, 0);
            
            // Arrow background
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + scheme[? uiScheme.FLArrowBack]);
            draw_rectangle((side == 1) ? (__uiMAX_WIDTH - 2 - 16) : -16, 2, __uiMAX_WIDTH - 2, h, 0);
            
            var index = ds_list_find_index(__uiFancyQueue, GIID);
            uiFancyStuffDraw(2, __uiMAX_WIDTH - 2, h, index, flags);
            
            // Arrow
            draw_sprite(sprUIGroup, data[6], (side == 1) ? (__uiMAX_WIDTH - 2 - 16) : -16, 2);
            
            // Item
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            
            // Sprite
            if( uiFlag(flags, uiFlags.Sprite) ) {
                if( item > -1 && ext0[0] > -1 && 
                    idata[2] != noone && iext0[0] != noone ) {
                    draw_sprite_stretched(ext0[0], iext0[0], 2, 2, 16, 16);
                    matrix_add_translate(16 + 2, 0, 0);
                }
            }
            
            // Text
            if( item == -1 ) {
                draw_text(2, 2, data[1] == "" ? "Select something" : data[1]);
            } else {
                var t1 = idata[1], t2 = "";
                var p = string_pos("|", t1);
                if( p > 0 && string_char_at(t1, p - 1) != "\\" ) {
                    t2 = string_copy(t1, p + 1, string_length(t1));
                    t1 = string_copy(t1, 1, p - 1);
                }
                
                draw_set_color(inactive * uiFlag(__uiFLFlags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
                draw_text(2, 2, t1);
                if( t2 != "" ) {
                    draw_set_halign(fa_right);
                    draw_text(__uiMAX_WIDTH - 2 - 16 - 2, 2, t2);
                    draw_set_halign(fa_left);
                }
            }
            
            __uiFLIndex = item;
            
            __uiMAX_WIDTH += f;
            matrix_add_translate(-uiFlag(flags, uiFlags.Sprite) * (16 + 2), 16 + 1, 0);
            if( data[6] ) {
                var v = matrix_nullvertex();
                matrix_add_translate(0, 0, -1); // Move one layer up
                
                uiRender(list);
                
                matrix_set(matrix_world, matrix_build_identity());
                matrix_add_translate(v[0], v[1], v[2]);
            }
            
            // Not in range of list
            var f = (!in && mouse_check_button_released(mb_left) && (size * data[6]) && __uiClickZ == nullVertex[2]) && !uiFlag(flags, uiFlags.Inactive);
            data[@ 6] ^= q || f;
            
            if( abs(item - __uiFLIndex) ) {
                data[@ 2] = __uiFLIndex;
                if( script_exists(data[3]) ) script_execute(data[3], __uiFLIndex, data[1]);
                mouse_clear(mb_left);
                __uiClickZ = nullVertex[2] - 1;
                
                uiFancyStuffEnqueue(flags, GIID);
            } else {
                if( f && !data[6] ) {show_debug_message(__uiClickZ);
                    __uiClickZ = nullVertex[2];
                }
            }
            
            matrix_add_translate(0, 8, 0);
#endregion
            break;
            
        case uiType.FITEM:
#region
            var flags = (i == __uiFLIndex) * uiFlags.Inactive;
            var h = string_height(data[1]);
            var in = matrix_rect(2, 2, __uiMAX_WIDTH - 2 - 16, h - 1);
            var q = in * mouse_check_button_released(mb_left) && !uiFlag(__uiFLFlags | flags, uiFlags.Inactive);
            var ext0 = data[2];
            if( ext0 == noone ) {
                data[@ 2] = [-1];
                ext0 = data[2];
            }
            
            // Background
            var clickIn = scheme[? uiScheme.ClickIn];
            var gpBack  = scheme[? uiScheme.FLBack];
            var In      = scheme[? uiScheme.In];
            var __x__   = scheme[? uiScheme.Mod2Val];
            
            draw_set_color(make_color_rgb(gpBack[0] + __x__ * ((i + 1) % 2) + In * max(__uiFLIndex == i, in) + clickIn * q, 
                                          gpBack[1] + __x__ * ((i + 1) % 2) + In * max(__uiFLIndex == i, in) + clickIn * q, 
                                          gpBack[2] + __x__ * ((i + 1) % 2) + In * max(__uiFLIndex == i, in) + clickIn * q)
                         + inactive * uiFlag(__uiFLFlags | flags, uiFlags.Inactive));
            draw_rectangle(2, 2, __uiMAX_WIDTH - 2 - 16, h, 0);
            
            // Sprite
            if( uiFlag(__uiFLFlags, uiFlags.Sprite) ) {
                if( ext0 != noone ) {
                    draw_sprite_stretched(__uiFLEXT0[0], ext0[0], 2, 2, 16, 16);
                    matrix_add_translate(16 + 2, 0, 0);
                }
            }
            
            // Text
            var t1 = data[1], t2 = "";
            var p = string_pos("|", t1);
            if( p > 0 && string_char_at(t1, p - 1) != "\\" ) {
                t2 = string_copy(t1, p + 1, string_length(t1));
                t1 = string_copy(t1, 1, p - 1);
            }
            
            draw_set_color(inactive * uiFlag(__uiFLFlags | flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text(2, 2, t1);
            if( t2 != "" ) {
                draw_set_halign(fa_right);
                draw_text(__uiMAX_WIDTH - 2 - 16 * 2 - 2, 2, t2);
                draw_set_halign(fa_left);
            }
            
            if( q ) {
                __uiFLIndex = i;
            }
            
            matrix_add_translate(-uiFlag(__uiFLFlags, uiFlags.Sprite) * (16 + 2), 16 + 1, 0);
#endregion
            break;
            
        case uiType.CHECKBOX:
#region
            var flags = data[3];
            var check = data[2];
            
            var h = string_height(data[1]);
            var in = matrix_rect(2, 2, __uiMAX_WIDTH - 2 - 16, h + 2);
            var q = in && mouse_check_button_released(mb_left) && !uiFlag(flags, uiFlags.Inactive);
            
            // Background
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + merge_color(scheme[? uiScheme.CBNSel], scheme[? uiScheme.CBSel], check));
            if( uiFlag(flags, uiFlags.RoundRect) ) {
                draw_roundrect(2, 2, 16 + 2, 16 + 2, 0);
            } else {
                draw_rectangle(2, 2, 16 + 2, 16 + 2, 0);
            }
            
            // eeeeee boi, fancy!
            var index = ds_list_find_index(__uiFancyQueue, GIID);
            uiFancyStuffDraw(2, 16, 16, index, flags);
            
            // Text
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text(2 + 16 + 8, 2, data[1]);
            
            if( q && __uiClickZ == nullVertex[2] ) {
                // Check
                data[@ 2] ^= true;
                uiFancyStuffEnqueue(flags, GIID); // Enqueue
                if( script_exists(data[4]) ) script_execute(data[4], data[2], data[1]);
            }
            
            matrix_add_translate(0, h + 8, 0);
#endregion
            break;
            
        case uiType.LIST:
#region
            var list = data[3];
            var release = data[2];
            var flags = data[1];
            
            __uiLFlags = flags;
            __uiLRelease = release;
            
            uiRender(list);
            
#endregion
            break;
            
        case uiType.ITEM:
#region
            var h = string_height("C");
            var in = matrix_rect(2, 2, __uiMAX_WIDTH - 2 - 16 * 2, h - 2);
            var q = in * mouse_check_button_pressed(mb_left);
            
            // Background
            var clickIn = scheme[? uiScheme.ClickIn];
            var gpBack  = scheme[? uiScheme.ItemBack];
            var In      = scheme[? uiScheme.In];
            var __x__   = scheme[? uiScheme.Mod2Val];
            
            draw_set_color(make_color_rgb(gpBack[0] + __x__ * (i % 2) + In * in + clickIn * q, 
                                          gpBack[1] + __x__ * (i % 2) + In * in + clickIn * q, 
                                          gpBack[2] + __x__ * (i % 2) + In * in + clickIn * q) + inactive * uiFlag(__uiLFlags, uiFlags.Inactive));
            draw_rectangle(2, 2, __uiMAX_WIDTH - 2 - 16 * 2, h + 1, 0);
            
            // Text
            draw_set_color(inactive * uiFlag(__uiLFlags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_text(2, 2, data[1]);
            
            if( uiFlag(__uiLFlags, uiFlags.Draggable) && q && __uiClickZ == nullVertex[2] && !uiFlag(__uiLFlags, uiFlags.Inactive) ) {
                __uiDragItem = uiPack(data, __uiLRelease);
                __uiDragWidth = __uiMAX_WIDTH;
            }
            
            matrix_add_translate(0, h, 0);
#endregion
            break;
            
        case uiType.DRAGGABLE:
#region
            var flags = data[3];
            var h = string_height("C");
            
            // Title
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_set_halign(fa_center);
                draw_text((__uiMAX_WIDTH - 16 * 2 - 2) / 2, 2, data[1]);
            draw_set_halign(fa_left);
            matrix_add_translate(0, h, 0);
            
            // 
            var in = matrix_rect(2, 2, __uiMAX_WIDTH - 2 - 16 * 2, h - 2);
            var q = in * mouse_check_button_released(mb_left) && !uiFlag(flags, uiFlags.Inactive);
            var item = data[2];
            
            // Background
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + scheme[? uiScheme.DrggblBack]);
            draw_rectangle(2, 2, __uiMAX_WIDTH - 2 - 16 * 2, h + 1, 0);
            
            // Text
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            if( item == noone ) {
                draw_text(2, 2, "Drop item here");
            } else {
                draw_text(2, 2, item[1]);
            }
            
            if( q ) {
                if( __uiDragItem != -1 ) {
                    data[@ 2] = __uiDragItem;
                    __uiDragItem = -1;
                }
            }
            
            if( in && mouse_check_button_pressed(mb_left) && !uiFlag(flags, uiFlags.Inactive) ) {
                // Drag item
                if( item != noone ) __uiDragItem = item;
                data[@ 2] = noone;
            }
            
            matrix_add_translate(0, h + 8, 0);
#endregion
            break;
            
        case uiType.VARTABSPACE:
#region
            var list = data[3];
            var values = uiValueArray(data[1]);
            
            __uiVTSValue = data[1];
            __uiVTSFlags = data[2];
            __uiVTSValues = values;
            
            SV_VarTabID = "(null)";
            
            uiRender(list);
            
            SV_VarTabID = "(null)";
#endregion
            break;
            
        case uiType.VARTAB:
#region
            if( !uiFlag(__uiVTSValues, 1 << (i + 1)) ) { continue; }
            
            var header = scheme[? uiScheme.Header];
            var h = string_height("C");
            
            // Background
            draw_set_color(make_colour_rgb(header[0], header[1], header[2]));
            draw_rectangle(2, 2, __uiMAX_WIDTH - 2, 2 + h, 0);
            
            // Title
            draw_set_color(make_colour_rgb(text[0], text[1], text[2]));
            draw_text(2, 2, data[1]);
            
            SV_VarTabID = data[1];
            
            matrix_add_translate(2, 2 + h, 0);
            
            // 
            uiRender(data[2]);
            
            // 
            matrix_add_translate(-2, 8, 0);
            
#endregion
            break;
            
        case uiType.CODEEDITOR:
#region
            var text = data[1];
            var flags = data[2];
            var Tokens = data[3];
            var isAnalized = data[4];
            var Analizing = data[5]; // Run time code analization
            var ErrorList = data[6];
            var Full = data[8];
            var VEC = [0, 0];
            
            // Check for lists
            if( uiFlag(flags, uiFlags.ErrorHightlight) ) {
                if( !ds_exists(ErrorList, ds_type_list) ) ErrorList = ds_list_create();
                data[@ 6] = ErrorList;
            } else {
                if( ds_exists(ErrorList, ds_type_list) ) ds_list_destroy(ErrorList);
                data[@ 6] = ErrorList;
            }
            
            if( uiFlag(flags, uiFlags.AutoHightlight) ) {
                if( !ds_exists(Tokens, ds_type_list) ) Tokens = ds_list_create();
                data[@ 3] = Tokens;
            } else {
                if( ds_exists(Tokens, ds_type_list) ) ds_list_destroy(Tokens);
                data[@ 3] = Tokens;
            }
            
            draw_set_color(c_dkgray);
            draw_rectangle(2, 2, __uiMAX_WIDTH - 2, data[10] + 2, 0);
            
            var h = string_height("C");
            
            // Regions
            var lst = data[12];
            if( !ds_exists(lst, ds_type_list) ) {
                data[@ 12] = ds_list_create();
                lst = data[12];
            }
            
            // Draw line numbers
            var regionCount = data[11];
            var __qq = uiFlag(flags, uiFlags.LineNumbers);
            if( __qq || regionCount > 0 ) {
                var w = 16 * (regionCount > 0) + 6 + string_width("000"); // Instead of '000' place n number of 0, 
                                                                          // to have some space for bigger numbers
                draw_set_color(c_black);
                draw_line(w, 2, w, data[10]);
                
                for( var j = 0; j < ds_list_size(lst); j++ ) {
                    var d = lst[| j];
                    
                    draw_sprite(sprUIGroup, d[0], w - 16, d[1]); // Draw open / close sign
                    
                    // Close / Open region
                    if( mouse_check_button_released(mb_left) && matrix_rect(w - 16, d[1], w - 1, d[1] + h) ) {
                        d[@ 0] ^= true;
                    }
                }
                
                if( __qq ) {
                    draw_set_color(uiCodeHightlight[? uiCode.Number]);
                    draw_set_halign(fa_right);
                        
                        for( var j = 0; j < data[10] / h; j++ ) {
                            draw_text(w - 2 - 16 * (regionCount > 0), 2 + j * h, string(j + 1));
                        }
                        
                    draw_set_halign(fa_left);
                }
                
                matrix_add_translate(w + 2, 0, 0);
            }
            
            // Run code tokenization
            if( uiFlag(flags, uiFlags.AutoHightlight) ) {
                #region Code tokenization
                if( !isAnalized ) {
                    if( Analizing ) {
                        var Index = data[7];
                        
                        repeat( 10 ) {
                            var char = string_char_at(text, Index);
                            var p = string_char_at(text, Index - 1);
                            
                            if( string_digits(char) == char || char == "." && string_digits(p) == p ) { // Real
                                var kw = char;
                                while( true ) {
                                    Index++;
                                    char = string_char_at(text, Index);
                                    
                                    if( (string_digits(char) == char) || char == "." ) {
                                        kw += char;
                                    } else {
                                        Index--;
                                        break;
                                    }
                                }
                                
                                ds_list_add(Tokens, [real(kw), uiCode.Number]);
                            } else if( ord(char) >= ord("a") && ord(char) <= ord("z")
                                    || ord(char) >= ord("A") && ord(char) <= ord("Z")
                                    || char == "_" ) { // Keyword
                                var kw = char;
                                while( true ) {
                                    Index++;
                                    char = string_char_at(text, Index);
                                    
                                    if( ord(char) >= ord("a") && ord(char) <= ord("z")
                                     || ord(char) >= ord("A") && ord(char) <= ord("Z")
                                     || (string_digits(char) == char) || char == "_" ) {
                                        kw += char;
                                    } else {
                                        Index--;
                                        break;
                                    }
                                }
                                
                                //show_debug_message(kw);
                                var tok = uiCodeTokens[? kw];
                                ds_list_add(Tokens, [kw, tok == undefined ? uiCode.Word : tok]);
                            } else if( char == "'" || char == "\"" ) {
                                var kw = char;
                                var start = char;
                                
                                while( true ) {
                                    Index++;
                                    char = string_char_at(text, Index);
                                    
                                    if( char == start ) {
                                        kw += char;
                                    } else {
                                        Index--;
                                        break;
                                    }
                                }
                                
                                ds_list_add(Tokens, [kw, uiCode.String]);
                            } else {
                                var kw, token = uiCode.Other;
                                
                                switch( char ) {
                                    case "/": // Comments
                                        switch( string_char_at(text, Index + 1) ) {
                                            case "/":
                                                var count = 0; Index++;
                                                while( string_char_at(text, Index) != "\n" ) {
                                                    Index++;
                                                    count++;
                                                }
                                                
                                                Index--;
                                                kw = string_copy(text, Index - count, count);
                                                
                                                token = uiCode.Comment;
                                                break;
                                                
                                            case "*":
                                                var count = 0; Index++;
                                                while !( string_char_at(text, Index) == "*" && string_char_at(text, Index + 1) == "/" ) {
                                                    Index++;
                                                    count++;
                                                }
                                                
                                                kw = string_copy(text, Index - count - 1, count + 3);
                                                Index++;
                                                
                                                token = uiCode.Comment;
                                                break;
                                        }
                                        break;
                                        
                                    case "\\": // 
                                        kw = char;
                                        Index++;
                                        
                                        switch( string_char_at(kw, Index) ) {
                                            case "t": kw += "    "; break;
                                            case "n": kw += "\n"; break;
                                            case "\\": kw += "\\"; break;
                                        }
                                        break;
                                        
                                    case "\n":
                                        // New line
                                        //show_debug_message("\\" + char + " " + string(Index));
                                        kw = char;
                                        break;
                                        
                                    case "#":
                                        // Preprocessor
                                        var count = 0; Index++;
                                        while( string_char_at(text, Index) != "\n" ) {
                                            Index++;
                                            count++;
                                        }
                                        
                                        Index--;
                                        kw = string_copy(text, Index - count, count);
                                        
                                        var p = string_rpos(" ", kw);
                                        var sbt = string_copy(kw, p + 1, string_length(kw)); // Find additional word
                                        
                                        token = uiCode.PreProcess;
                                        
                                        if( ds_list_find_index(uiCodePreProcess, sbt) == -1 ) { // String is apparantly not preprocessor
                                            if( string_pos("region", kw) && string_pos("endregion", text) ) {
                                                data[@ 11]++;
                                                ds_list_add(lst, [true, string_height(string_copy(text, 1, Index)) - h]); // Add token, of [x, height]
                                            }
                                            
                                            kw = string_delete(kw, p + 1, string_length(kw)); // Delete string
                                            
                                            // Put preprocess
                                            ds_list_add(Tokens, [kw, uiCode.PreProcess]);
                                            
                                            // Put argument
                                            kw = sbt;
                                            
                                            if( (string_pos("'" , kw) && string_rpos("'" , kw) && string_count("'" , kw) > 1)
                                             || (string_pos("\"", kw) && string_rpos("\"", kw) && string_count("\"", kw) > 1) ) {
                                                token = uiCode.String; // Put string
                                            } else {
                                                var tok = uiCodeTokens[? sbt];
                                                token = tok == undefined ? uiCode.Word : tok;
                                            }
                                        }
                                        break;
                                        
                                    default:
                                        // Compress string
                                        var start = char; kw = char
                                        while( char ) {
                                            char = string_char_at(text, Index);
                                            
                                            if( char == start ) {
                                                kw += char;
                                            } else {
                                                Index--;
                                                break;
                                            }
                                        }
                                        break;
                                }
                                
                                if( kw != "" ) ds_list_add(Tokens, [kw, token]);
                            }
                            
                            Index++;
                            
                            // Tokenization is done!
                            if( Index > string_length(text) ) {
                                isAnalized = true;
                                Analizing = false;
                                break; // Stop the loop
                            }
                        }
                        
                        data[@ 7] = Index;
                    } else { // Run code tokenization
                        Analizing = true;
                        Full = false;
                        
                        ds_list_clear(Tokens);
                        data[@ 7] = 1;
                        data[@ 9] = 0;
                    }
                }
                #endregion
                
                var Index2 = data[9];
                if( (Analizing || isAnalized) /*/&& !Full/**/ && ds_list_size(Tokens) > 0 ) {
                    // Generate string
                    var _x = 2;
                    var _y = 2;
                    var cnt = 0;
                    
                    for( var j = 0; j < ds_list_size(Tokens); j++ ) {
                        var token = Tokens[| j];
                        
                        if( token[0] == "\n" ) {
                            _y += h;
                            _x = 0;
                            continue;
                        } else {
                            var drw = false;
                            var pr = "#pragma region";
                            var per = "#pragma endregion";
                            var test1 = string_copy(token[0], 1, string_length(pr)) == pr;
                            
                            if( string_char_at(token[0], 1) == "#"
                             && (test1 || string_copy(token[0], 1, string_length(per)) == per)) {
                                if( test1 ) {
                                    // #pragma region
                                    var d = lst[| cnt];
                                    
                                    if( !d[0] ) {
                                        var tok = Tokens[| ++j]; // String
                                        
                                        var tkn = Tokens[| ++j];
                                        while( j < ds_list_size(Tokens) && (tkn[0] != "#pragma endregion") ) {
                                            // Skip to #pragma endregion or end of code
                                            tkn = Tokens[| ++j];
                                        }
                                        
                                        drw = true;
                                    }
                                }
                                
                                cnt++; // 
                            }
                            
                            draw_set_color(uiCodeHightlight[? token[1]]);
                            draw_text(_x, _y, token[0]);                    // Draw text
                            
                            _x += string_width(token[0]);
                            if( token[1] == uiCode.Comment ) {
                                _y += string_height(token[0]) - h;
                            }
                            
                            if( drw ) {
                                draw_set_color(uiCodeHightlight[? tok[1]]);
                                draw_text(_x, _y, tok[0]);                    // Draw text
                                
                                _x += string_width(tok[0]);
                            }
                        }
                    }
                    
                    VEC = [0, _y];
                    data[@ 10] = _y + h - 2;
                }
                
                // Update values
                data[@ 5] = Analizing;
                data[@ 4] = isAnalized;
                data[@ 8] = Full;
                data[@ 9] = Index2;
            } else {
                data[@ 10] = string_height(text);
                
                draw_set_color(uiCodeHightlight[? uiCode.Word]);
                draw_text(2, 2, text);
            }
            
            matrix_add_translate(VEC[0], VEC[1], 0);
#endregion
            break;
            
        case uiType.INSTFIELD:
#region
            var vSpace = data[1];
            var variable = data[2];
            
            var val = is_string(variable) ? array_length_1d(variable_instance_get(id, variable)) : ds_list_size(variable);
            
            for( var i = 0; i < val; i++ ) {
                SV_InstanceID = i;
                uiRender(0, 0, data[3]); // Render
            }
            
            SV_InstanceID = -1;
#endregion
            break;
            
        case uiType.TEXTURE:
#region
            var flags = data[2];
            var w = __uiMAX_WIDTH - 2;
            var h = (uiFlag(flags, uiFlags.Squared) || data[1] == NULL) ? w : (w / texture_get_width(data[1]));
            
            if( data[1] != NULL ) {
                // Add Ratio flag, so texture will be in better rect
                draw_primitive_begin_texture(pr_trianglefan, data[1]);
                    
                    draw_vertex_texture(2    , 2    , 0, 0);
                    draw_vertex_texture(w - 2, 2    , 1, 0);
                    draw_vertex_texture(w - 2, h - 2, 1, 1);
                    draw_vertex_texture(2    , h - 2, 0, 1);
                    
                draw_primitive_end();
            } else {
                draw_set_halign(fa_center);
                draw_text(w / 2, h / 2, "No texture provided! (NULL)");
                draw_set_halign(fa_left);
            }
            
            matrix_add_translate(0, h, 0);
#endregion
            break;
            
        case uiType.SEPARATOR:
#region
            var h = 4;
            var header = scheme[? uiScheme.Header];
            draw_set_color(make_color_rgb(header[0], header[1], header[2]));
            draw_rectangle(2, 8 + 2, __uiMAX_WIDTH - 2, 8 + h * 2 + 2, 0);
            
            matrix_add_translate(0, h + (8 + 2) * 2, 0);
#endregion
            break;
            
        case uiType.CHOOSESPACE:
#region
            var list = data[5];
            var flags = data[4];
            
            __uiCSChFlg = data[1];
            __uiCSFlags = data[3];
            __uiCSCallB = data[4];
            
            __uiCSSize  = ds_list_size(list);
            __uiCSStep  = (__uiMAX_WIDTH - 16 * 2) / __uiCSSize;
            
            var h = data[2] == "" ? 0 : string_height_ext(data[2], -1, __uiMAX_WIDTH - 2);
            
            // Title
            draw_set_color(inactive * uiFlag(flags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_set_halign(fa_center);
                draw_text(__uiMAX_WIDTH / 2, 0, data[2]);
            draw_set_halign(fa_left);
            
            var v = matrix_nullvertex();
            
            // Render variants
            uiRender((__uiMAX_WIDTH - 2 * 16) / 2 - __uiCSStep * (__uiCSSize / 2), h, list);
            
            // Move pointer down a bit, but retrieve old x position
            var n = matrix_nullvertex();
            matrix_add_translate(-(n[0] - v[0]), h + 16, 0);
            
            data[@ 1] = __uiCSChFlg; // Overwrite prev. flags
#endregion
            break;
            
        case uiType.CHOOSE:
#region
            var check = uiFlag(__uiCSChFlg, 1 << (i + 0));
            
            var in = matrix_rect(0, 0, __uiCSStep, 32);
            
            // Background
            draw_set_color(inactive * uiFlag(__uiCSFlags, uiFlags.Inactive) + merge_color(scheme[? uiScheme.CBNSel], scheme[? uiScheme.CBSel], check));
            if( uiFlag(__uiCSFlags, uiFlags.RoundRect) ) {
                var edge = ( i == 0 ) || ( i == (__uiCSSize - 1) );
                
                if( edge ) {
                    draw_roundrect(0, 0, __uiCSStep, 32, 0);
                    
                    // This button on the edge (first / last)
                    if( i == 0 ) {
                        draw_rectangle(__uiCSStep / 2, 1, __uiCSStep, 33, 0);
                    } else if( i == (__uiCSSize - 1) ) {
                        draw_rectangle(0, 1, __uiCSStep / 2, 33, 0);
                    }
                } else {
                    draw_rectangle(0, 1, __uiCSStep, 33, 0);
                }
            } else { // No RoundRect
                draw_rectangle(0, 0, __uiCSStep, 32, 0);
            }
            
            draw_set_color(inactive * uiFlag(__uiCSFlags, uiFlags.Inactive) + make_color_rgb(text[0], text[1], text[2]));
            draw_set_halign(fa_center);
                draw_text(__uiCSStep / 2, 32 / 4, data[1]);
            draw_set_halign(fa_left);
            
            if( in && mouse_check_button_pressed(mb_left) ) {
                var flag = 1 << (i + 0);
                
                if( uiFlag(__uiCSFlags, uiFlags.Selectable) ) { // Multiselection
                    __uiCSChFlg = (check ? (__uiCSChFlg & ~flag) : (__uiCSChFlg | flag));
                } else {
                    __uiCSChFlg = (!check * flag); // Toggle
                }
                
                if( script_exists(__uiCSCallB) ) {
                    script_execute(__uiCSCallB, data);
                }
                
                //show_debug_message(__uiCSChFlg);
            }
            
            matrix_add_translate(__uiCSStep + 3, 0, 0);
#endregion
            break;
            
    }
}
