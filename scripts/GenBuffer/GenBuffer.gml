/// @description  GenBuffer(surf, [w], [h]);
/// @function  GenBuffer
/// @param surf
/// @param [w]
/// @param [h]
var s = argument[0];

if( !surface_exists(s) ) {
    var q = (argument_count == 1);
    var z = (argument_count == 3);
    show_debug_message([q ? WIDTH  : argument[1], 
                          q ? HEIGHT : (z ? argument[2] : argument[1])]);
    return surface_create(q ? WIDTH  : argument[1], 
                          q ? HEIGHT : (z ? argument[2] : argument[1]));
}

return s;
