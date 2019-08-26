/// @arg data
/// @arg [index]
var data = argument[0];
var ind = argument_count == 1 ? -1 : argument[1];
var item = ds_list_find_value(data[0], data[1]);

switch( item[0] ) {
    case uiType.INT  :              return floor(lerp(item[3], item[4], item[2]));
    case uiType.FLOAT:              return lerp(item[3], item[4], item[2]);
    case uiType.VARTABSPACE:        return item[1];
    case uiType.TREEVIEW:           return array_get(item[5], 1);
    case uiType.FELLOUTLIST:        
    case uiType.CHECKBOX:           return item[2];
    case uiType.CHOOSESPACE:        return item[1];
    case uiType.COLORSELECTOR: 
        var flags = item[2];
        if( uiFlag(flags, uiFlags.CSCircle) ) { // Circle
            var scheme = __uiSchemeID;
            
            // Get point count
            var count = 0;
            for( var j = 0; j < 4; j++ ) {
                if( !uiFlag(flags, 1 << (log2(uiFlags.CSPoint1) + j)) ) { break; } // End loop, no more points
                count++;
            }
            
            return uiTriangulateColor(array_get(item[3], 1), count, scheme[? uiScheme.CSRad]);
        } else { // Rectangle
            
        }
        
    //case uiType.INSTFIELD:          return item[];
}

show_debug_message("uiGetValue::I do n't support this component yet!");
return 0;
