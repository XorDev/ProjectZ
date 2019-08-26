ObjectIndex = 1;

MatrixIdentity;
if( pass & eRenderFlags.DontShow ) { return; }

for( var i = 0; i < min(ModelLastIndex, array_length_1d(ModelList)); i++ ) {
    var data = ModelList[i];
    
    if( !is_array(data) ) { continue; }
    
    var rot   = data[eModelItem.Rotation];
    var scale = data[eModelItem.Scale   ];
    var pos   = data[eModelItem.Position];
    var flags = data[eModelItem.Flags   ];
    
    // Don't render if this model won't be in light buffer
    if( (pass & eRenderFlags.Depth) && (flags & eRenderFlags.NoDepth) ) { continue; }
    
    // Don't render if this model shouldn't be rendered
    if( flags & eRenderFlags.DontShow ) { continue; }
    
    // Disable zwriting if needed
    if( flags & eRenderFlags.ZWDisable ) { gpu_set_zwriteenable(false); }
    
    // Update transformation
    if( ObjectIndex == Selection && Transformed == false ) {
        if( TransformFlags & eTransformFlags.Position ) {
            if( TransformFlags & eTransformFlags.Relative ) {
                data[@ eModelItem.Position] = [pos[0] + TargetTransform[0], pos[1] + TargetTransform[1], pos[2] + TargetTransform[2]];
            } else {
                data[@ eModelItem.Position] = TargetTransform;
            }
        }
        
        Transformed = true;
        
        rot   = data[eModelItem.Rotation];
        scale = data[eModelItem.Scale   ];
        pos   = data[eModelItem.Position];
    }
    
    // Set externals
    EXT0 = data[eModelItem.External0];
    
    // Default rotation
    matrix_add_rotation(270, 0, 0);
    
    // Transform
    matrix_add_rotation(rot[0], 0, 0);
    matrix_add_rotation(0, rot[1], 0);
    matrix_add_rotation(0, 0, rot[2]);
    matrix_add_scale(scale[0], scale[1], scale[2]);
    matrix_add_translate(pos[0], pos[1], pos[2]);
    
    // Set pass flags
    var o = pass;
    pass |= flags;
    
    // Render model
    RenderModel(data[eModelItem.Model]);
    
    // Restore old
    pass = o;
    
    // 
    MatrixIdentity;
    
    // Re-enable
    if( flags & eRenderFlags.ZWDisable ) { gpu_set_zwriteenable(true); }
}
