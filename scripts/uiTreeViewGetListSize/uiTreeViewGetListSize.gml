/// @arg list
var list = argument0;
var count = ds_list_size(list);

for( var i = 0; i < ds_list_size(list); i++ ) {
    var q = list[| i];
    show_debug_message(q);
    if( q[0] == uiType.TFOLDER ) {
        count += uiTreeViewGetListSize(q[4]);
    }
}

return count;
