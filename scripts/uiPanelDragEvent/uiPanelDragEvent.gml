// 
if( mouse_check_button(mb_left) && __uiMove ) {
    // Move
    __uiMoveData[@ 4] = __uiMX - __uiMoveP[0];
    __uiMoveData[@ 5] = __uiMY - __uiMoveP[1];
}

if( mouse_check_button_released(mb_left) ) {
    // Disable
    __uiMove = false;
}