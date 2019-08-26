/// @arg model
/// @arg rotation
/// @arg scale
/// @arg position
/// @arg [flags]
/// @arg [ext0]
if( ModelLastIndex >= 255 ) { show_debug_message("Scene model limit reached!"); return; }

ModelList[ModelLastIndex] = [
    argument[0], argument[1], argument[2], argument[3], 
    (argument_count > 4) ? argument[4] : 0, 
    (argument_count > 5) ? argument[5] : -1, 
    
];

ModelLastIndex++;
