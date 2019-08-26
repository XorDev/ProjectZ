/// @arg title
/// @arg list
/// @arg icons
/// @arg [flags]
/// @arg [ext0]
/// @arg [callback]
ds_list_add(uiCreationTrace, [uiType.TREEVIEW, argument[0], argument[1], 
                              (argument_count > 2) ? argument[2] : -1, 
                              (argument_count > 3) ? argument[3] : uiFlags.Null, 
                              (argument_count > 4) ? argument[4] : noone, 
                              uiTreeViewGetListSize(argument[1]),                 // Note: update this value 
                              (argument_count > 5) ? argument[5] : noone]);       // In array to update tree view

return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];
// Item example:
// [0] - Type[TFOLDER / TITEM]
// [1] - Title
// [2] - image index
// [3] - Flags for handling drag's release event
// [4...] - External data
// if folder 
//      [4] - List of items
//      [5] - Opened or closed
