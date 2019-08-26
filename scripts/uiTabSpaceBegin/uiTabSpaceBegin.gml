/// @arg currentTab
/// @arg [flags]
var list = ds_list_create();
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.TABSPACE, argument[0], 
                              (argument_count > 1) ? argument[1] : uiFlags.Hor, 
                              list]);
uiCreationTrace = list;
