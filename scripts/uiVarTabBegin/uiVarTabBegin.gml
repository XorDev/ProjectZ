/// @arg title
var list = ds_list_create(); var t = uiCreationTrace;
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.VARTAB, argument[0], 
                              list]);
uiCreationTrace = list;
return [t, ds_list_size(t) - 1];
