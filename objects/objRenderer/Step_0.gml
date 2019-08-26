/// @desc Debug Hot keys
global.MODE[eMode.Selection] =  keyboard_check(vk_alt) && !keyboard_check(vk_control) && !keyboard_check(vk_shift); //  Alt  + {Ctrl} + {Shift}
global.MODE[eMode.Transform] =  keyboard_check(vk_alt) &&  keyboard_check(vk_control) && !keyboard_check(vk_shift); //  Alt  +  Ctrl  + {Shift}
global.MODE[eMode.Placing  ] = !keyboard_check(vk_alt) &&  keyboard_check(vk_control) && !keyboard_check(vk_shift); // {Alt} +  Ctrl  + {Shift}
global.MODE[eMode.Drawing  ] =                            !keyboard_check(vk_control) &&  keyboard_check(vk_shift); // [Alt] + {Ctrl} +  Shift


global.MODE[eMode.Any] = global.MODE[eMode.Selection] | global.MODE[eMode.Transform] | global.MODE[eMode.Placing]
    | (keyboard_check(vk_alt) ? global.MODE[eMode.Drawing] : 0);

// Place light
if( uiGetValue(bvDSSDO) && keyboard_check_pressed(vk_tab) ) {
    gLightList_Pos[gLightIndex * 3 + 0] = objCamera.x;
    gLightList_Pos[gLightIndex * 3 + 1] = objCamera.y;
    gLightList_Pos[gLightIndex * 3 + 2] = objCamera.z;
    
    if( gLightIndex % 2 == 0 ) {
        gLightList_Col[gLightIndex * 3 + 0] = .7;
        gLightList_Col[gLightIndex * 3 + 1] = .9;
        gLightList_Col[gLightIndex * 3 + 2] = 0;
    } else {
        gLightList_Col[gLightIndex * 3 + 0] = .9;
        gLightList_Col[gLightIndex * 3 + 1] = .3;
        gLightList_Col[gLightIndex * 3 + 2] = .2;
    }
    
    gLightIndex = (gLightIndex + 1) % 10;
}

if( global.MODE[eMode.Drawing] ) {
    if( keyboard_check_pressed(vk_tab) ) {
        gChannelIndex = (gChannelIndex + 1) % 3;
    }
    
    gBrushSize += (mouse_wheel_up() - mouse_wheel_down());
}
