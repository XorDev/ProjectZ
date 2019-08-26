/// @arg px
/// @arg py
/// @arg xoff
/// @arg yoff
/// @arg ui
var list = uiRectangles[? argument4];

if( list == undefined || !ds_exists(list, ds_type_list) ) return false;
for( var i = 0; i < ds_list_size(list); i++ ) {
    var rect = list[| i];
    if( point_in_rectangle(argument0 - argument2, argument1 - argument3, 
                           rect[0], rect[1], rect[2], rect[3]) ) {
        return true;
    }
}

return false;
