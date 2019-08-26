/// @arg title
var list = ds_list_create();
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.TAB, argument[0], list]);
uiCreationTrace = list;
