/// @arg type
/// @arg {size1} ext0
/// @arg {size2} [ext1]
/// @arg [pos[v. h]]
var list = ds_list_create();
ds_stack_push(uiCreationStack, uiCreationTrace);
ds_list_add(uiCreationTrace, [uiType.SCROLL, argument[0], (argument_count > 1) ? argument[1] : -1, 
                              (argument_count > 2) ? argument[2] : -1, 
                              (argument_count > 3) ? argument[3] : noone, list, false]);
uiCreationTrace = list;
