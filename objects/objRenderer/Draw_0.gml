/// @desc Deferred Renderer
// RT Update
rtLight      = GenBuffer(rtLight  , objLightDirectional.w, objLightDirectional.w);
rtHDR0       = GenBuffer(rtHDR0   , WIDTH, HEIGHT);
rtHDR1       = GenBuffer(rtHDR1   , WIDTH, HEIGHT);
rtDepth      = GenBuffer(rtDepth  , WIDTH, HEIGHT);
rtNormal     = GenBuffer(rtNormal , WIDTH, HEIGHT);
rtSSDOAcc    = GenBuffer(rtSSDOAcc, WIDTH, HEIGHT);
rtSSDOBlr    = GenBuffer(rtSSDOBlr, WIDTH, HEIGHT);
rtSSDOBr2    = GenBuffer(rtSSDOBr2, WIDTH, HEIGHT);
rtSSDORes    = GenBuffer(rtSSDORes, WIDTH, HEIGHT);

rtHDRAvgCurr = GenBuffer(rtHDRAvgCurr, WIDTH * HDRDel, HEIGHT * HDRDel);
for( var i = 0; i < HDRCycles; i++ ) {
    rtHDRAvg[HDRCycles - 1 - i] = GenBuffer(rtHDRAvg[HDRCycles - 1 - i], WIDTH * HDRDel * (i + 1), HEIGHT * HDRDel * (i + 1));
}

// 
if( first ) { first = false; return; }

//objLightDirectional.x += keyboard_check(vk_alt);

gpu_set_blendenable(false);

if( uiGetValue(bvShadows) ) {
    // Light buffer
    surface_set_target(rtLight);
        
        draw_clear_alpha(0, 0);
        
        SetLightCamera;
        
        pass = eRenderFlags.Opaque | eRenderFlags.Depth;
        RenderScene();
        
    surface_reset_target();
}

// VPL
if( uiGetValue(bvBakeVPL) ) {
    uiSetValue(bvBakeVPL, false);
    
    vplGenBuffers(vplTarget0);
    
    pass = eRenderFlags.Opaque;
    for( var i = -1; i < vplIterator(vplTarget0, i); i++ ) {
        if( i == -1 ) { continue; }
        RenderScene();
    }
    
    vplIteratorEnd();
}

// Clear with sky color
surface_set_target(rtHDR0);
    draw_clear_alpha($CC7F66, 1);
surface_reset_target();

// Clear with 0 alpha black
surface_set_target_ext(0, rtHDR1  );
surface_set_target_ext(1, rtDepth );
surface_set_target_ext(2, rtNormal);
    
    draw_clear_alpha(0, 0);
    
surface_reset_target();

// Scene in HDR
surface_set_target_ext(0, rtHDR0  );
surface_set_target_ext(1, rtHDR1  );
surface_set_target_ext(2, rtDepth );
surface_set_target_ext(3, rtNormal);
    
    SetCamera;
    
    pass = eRenderFlags.Opaque;
    RenderScene();
    
surface_reset_target();

// 
gpu_set_blendenable(true);
