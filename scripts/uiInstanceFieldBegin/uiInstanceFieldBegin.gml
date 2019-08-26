/// @arg {VarTabSpace} var
/// @arg {string} variableName{array}
var list = ds_list_create(); var t = uiCreationTrace;
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.INSTFIELD, argument[0], argument[1], list]);
uiCreationTrace = list;
return [t, ds_list_size(t) - 1];
