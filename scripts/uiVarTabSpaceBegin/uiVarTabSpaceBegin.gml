/// @arg [selected]
/// @arg [flags]
var list = ds_list_create(); var t = uiCreationTrace;
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.VARTABSPACE, (argument_count > 0) ? argument[0] : (1 << 0), 
                              (argument_count > 1) ? argument[1] : uiFlags.Null, 
                              list]);
uiCreationTrace = list;
return [t, ds_list_size(t) - 1];
