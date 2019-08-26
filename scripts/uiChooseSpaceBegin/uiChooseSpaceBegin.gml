/// @arg current
/// @arg title
/// @arg [flags]
/// @arg [callback]
var list = ds_list_create();
var p = ds_list_size(uiCreationTrace); var t = uiCreationTrace;
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.CHOOSESPACE, argument[0], argument[1], 
                              (argument_count > 2) ? argument[2] : 0, 
                              (argument_count > 3) ? argument[3] : noone, 
                              list]);
uiCreationTrace = list;
return [t, p];
