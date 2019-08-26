/// @arg [NULL]Texture
/// @arg [flags]
var flags = (argument_count > 1) ? argument[1] : uiFlags.Null;
ds_list_add(uiCreationTrace, [uiType.TEXTURE, argument[0], flags]);
return [uiCreationTrace, ds_list_size(uiCreationTrace) - 1];
