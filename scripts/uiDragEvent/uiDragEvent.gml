// Drag item
if( __uiDragItem != -1 ) {
    if( mouse_check_button(mb_left) ) {
        var l = ds_list_create(); ds_list_add(l, __uiDragItem);
        __uiMAX_WIDTH = __uiDragWidth;
        
        uiRender(__uiMX - __uiMAX_WIDTH / 2, __uiMY, l);
        
        ds_list_destroy(l);
    } else {
        if( mouse_check_button_released(mb_left) ) {
            // Execute callback
            var l = array_length_1d(__uiDragItem);
            if( script_exists(__uiDragItem[l - 1]) ) script_execute(__uiDragItem[l - 1], __uiDragItem);
        }
        
        __uiDragItem = -1;
    }
}
