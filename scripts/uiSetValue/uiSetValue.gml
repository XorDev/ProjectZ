/// @arg data
/// @arg value
var data = argument[0];
var val = argument[1];
var item = ds_list_find_value(data[0], data[1]);

switch( item[0] ) {
    case uiType.VARTABSPACE:
    case uiType.CHOOSESPACE:
    case uiType.TEXTURE    : item[@ 1] = val; break;
    case uiType.CHECKBOX   : item[@ 2] = val; break;
        
    default:
        show_debug_message("uiSetValue::I can't set value for this component yet!");
        break;
}
