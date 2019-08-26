/// @arg text
/// @arg [flags]
/// @arg [ext0]
ds_list_add(uiCreationTrace, [uiType.TEXT, argument[0], 
                              (argument_count > 1) ? argument[1] : uiFlags.Null, 
                              (argument_count > 2) ? argument[2] : noone]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];
// Where noone: it will be [1, 100, noone] in uiRender:
//    - 1 scroll pos
//    - 100 height max
//    - noone other externals like scripts or something else
