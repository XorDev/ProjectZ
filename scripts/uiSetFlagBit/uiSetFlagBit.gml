/// @arg data
/// @arg flag
/// @arg [bit] Otherwise will be toggled
var data = argument[0];
var flag = argument[1];

var item = ds_list_find_value(data[0], data[1]);
var q = (argument_count > 2) ? argument[2] : -1;

var f;
switch( item[0] ) {
    case uiType.COLORSELECTOR: f = 2; break;
    case uiType.SPRITE: case uiType.BUTTON: f = 3; break;
    case uiType.INT: case uiType.FLOAT: f = 5; break;
    case uiType.CHOOSESPACE: f = 3; break;
    case uiType.CHECKBOX: 
    default:
        show_debug_message("uiSetFlagBit::I do n't support this component! (" + string(item[0]) + ")");
        return 0;
}

if( q == -1 ) {
    item[@ f] = (uiFlag(item[f], flag) ? (item[f] & ~flag) : (item[f] | flag));
} else {
    item[@ f] = (!q ? (item[f] & ~flag) : (item[f] | flag));
}
