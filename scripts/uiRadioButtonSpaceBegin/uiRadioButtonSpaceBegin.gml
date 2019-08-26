/// @arg title
/// @arg [callback]
/// @arg [selectedID]
/// @arg [flags]
var list = ds_list_create(); var t = uiCreationTrace;
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.RADIOBUTTONSPACE, argument[0], 
                              (argument_count > 1) ? argument[1] : noone, 
                              (argument_count > 2) ? argument[2] : 0, 
                              (argument_count > 3) ? argument[3] : uiFlags.Null, 
                              list]);
uiCreationTrace = list;
return [t, ds_list_size(t) - 1];
