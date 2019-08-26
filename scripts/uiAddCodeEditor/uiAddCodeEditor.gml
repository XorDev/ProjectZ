/// @arg text
/// @arg [flags]
var flags = (argument_count > 1) ? argument[1] : uiFlags.Null;
ds_list_add(uiCreationTrace, [uiType.CODEEDITOR, argument[0], flags, 
                           // Tokens            is analyzed analyzing
                              ds_list_create(), false,      false, 
                              
                           // Error list
                              uiFlag(flags, uiFlags.ErrorHightlight) ? ds_list_create() : noone, 
                              
                           // Index Full   Index2 LastHeight Region Count Region list
                              1,    false, 1,     0,         0,           noone, 
                              
                           // 
                              
                              
                              ]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];
