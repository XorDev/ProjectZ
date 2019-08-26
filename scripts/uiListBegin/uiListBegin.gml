/// @arg [flags]
/// @arg [CallBackOnRelease]
var list = ds_list_create(); var t = uiCreationTrace;
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.LIST, (argument_count > 0) ? argument[0] : uiFlags.Null, (argument_count > 1) ? argument[1] : noone, list]);
uiCreationTrace = list;
return [t, ds_list_size(t) - 1];
