/// @arg ident
/// @arg w
/// @arg h
/// @arg index
/// @arg flags
var ident = argument0;
var w = argument1;
var h = argument2;
var index = argument3;
var flags = argument4;

var scheme = __uiSchemeID;

if( uiFlag(flags, uiFlags.Fancy) ) {
    if( index > -1 ) {
        // Draw fancy stuff
        var v = matrix_nullvertex();
        var value = __uiFancyQueue[| index + 1]; __uiFancyQueue[| index + 1] = lerp(value, 1, .1); // Get / Update
        var col = draw_get_color();
        var fancy = scheme[? uiScheme.Fancy];
        
        // Draw
        draw_set_color(merge_color(col, fancy, value / 1.25));
        
        var rect = [v[0] + ident, v[1] + ident]; // Setup SV_Rectangle
        rect[2] = rect[0] + w + ident / 2;
        rect[3] = rect[1] + h + ident / 2;
        
        // Clipping rectangle
        var skip = false;
        var __tmp__ = SV_ClipRectangle;
        if( __tmp__ == -1 ) {
            uiClipBegin(rect[0], rect[1], rect[2] - rect[0], rect[3] - rect[1]);        // No shader used right now
        } else {
            skip = matrix_rect(SV_ClipRectangle[0], SV_ClipRectangle[1], SV_ClipRectangle[2], SV_ClipRectangle[3]);
            
            if( !skip ) {
                SV_ClipRectangle = rect;                                                // Clip shader is used
                shader_set_uniform_f(_Clip, SV_ClipRectangle[0], SV_ClipRectangle[1], SV_ClipRectangle[2], SV_ClipRectangle[3]);
            }
        }
        
        if( !skip ) {
            draw_set_alpha(((value < .5) ? (value * 2) : ((1 - value) * 2)) * 2); // Set alpha
            
            // Draw circles
            uiCircle(ident + w / 2, ident + h / 2, value * (w + ident));
            
            draw_set_alpha(1);
        }
        
        if( __tmp__ == -1 ) {
            uiClipEnd();                                                                // No shader used right now
        } else {
            SV_ClipRectangle = __tmp__;                                                 // Clip shader is used
            shader_set_uniform_f(_Clip, SV_ClipRectangle[0], SV_ClipRectangle[1], SV_ClipRectangle[2], SV_ClipRectangle[3]);
        }
        
        if( value >= .98 ) { // Delete from list
            ds_list_delete(__uiFancyQueue, index + 1); // Delete value
            ds_list_delete(__uiFancyQueue, index + 0); // Delete GIID
        }
    }
} else {
    if( index > -1 ) { // Delete registers
        ds_list_delete(__uiFancyQueue, index + 1); // Delete value
        ds_list_delete(__uiFancyQueue, index + 0); // Delete GIID
    }
}
