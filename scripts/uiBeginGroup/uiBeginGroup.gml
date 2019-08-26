/// @arg name
/// @arg [opened]
/// @arg [flags]
var list = ds_list_create();
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.GROUP, argument[0], (argument_count > 1) ? argument[1] : false, 
                              (argument_count > 2) ? argument[2] : uiFlags.Null, list]);
uiCreationTrace = list;
