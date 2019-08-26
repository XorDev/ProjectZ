/// @arg list
/// @arg value
var list = argument0;
var val = argument1;

var arr = ds_list_create(), size = 0, /* U can delete next 2 */camList = ds_list_create(), sz2 = 0;
var bitfield = 0;

for( var i = 0; i < ds_list_size(list); i++ ) {
    var item = list[| i];
    
    if( item[0] == uiType.TFOLDER ) {
        var res = uiLog2Array(item[4], val);
        var r = res[1]; /* U can delete this */var c = res[2];
        
        bitfield |= res[0];
        
        // Put all vars to main array
        for( var j = 0; j < ds_list_size(r); j++ ) {
            ds_list_add(arr, r[| j]);
        }
        
        // Put all vars to main camera array
        /* U can delete this */
        for( var j = 0; j < ds_list_size(c); j++ ) {
            ds_list_add(camList, c[| j]);
        }
        
        /* U can delete this */ sz2 += ds_list_size(c);
        size += ds_list_size(r);
        ds_list_destroy(r);
        /* U can delete this */ ds_list_destroy(c);
    } else if( item[0] == uiType.TITEM ) {
        // Add item to array
        if( uiFlag(val, 1 << size) ) {
            ds_list_add(arr, item[1]);
            bitfield |= 1 << size;
            
            /* U can delete this */
            if( either(item[1], "Camera", "Plane") ) { ds_list_add(camList, item); sz2++; }
        }
    }
    
    size++;
}

return [bitfield, arr, camList];
