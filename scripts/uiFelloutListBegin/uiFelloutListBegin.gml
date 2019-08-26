/// @arg title
/// @arg [selectedID]
/// @arg [callback]
/// @arg [flags]
/// @arg [ext0]
var list = ds_list_create(); var t = uiCreationTrace;
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.FELLOUTLIST, argument[0], 
                              (argument_count > 1) ? argument[1] : 0, 
                              (argument_count > 2) ? argument[2] : noone, 
                              (argument_count > 3) ? argument[3] : uiFlags.Null, 
                              (argument_count > 4) ? argument[4] : noone, 
                              false, list]);
uiCreationTrace = list;
return [t, ds_list_size(t) - 1];
