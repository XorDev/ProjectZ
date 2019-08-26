gml_pragma("global", "macros();");

// 
#macro WIDTH  (window_get_width()) 
#macro HEIGHT (window_get_height())

#macro MatrixIdentity matrix_set(matrix_world, matrix_build_identity());
#macro SetCamera \
    matrix_set(matrix_projection, objCamera.mProj); \
    matrix_set(matrix_view, objCamera.mView);

#macro SetLightCamera \
    matrix_set(matrix_projection, objLightDirectional.mProj); \
    matrix_set(matrix_view, objLightDirectional.mView);

#region Model loader
#macro ML_showComments 1

global.m_MaterialMaps = ds_map_create();
global.m_map          = ds_map_create();
global.m_bound        = ds_map_create(); // Vertex Buffer
global.m_bounds       = ds_map_create(); // [Min.xyz, Max.xyz]
global.m_list         = ds_list_create();
global.m_col          = ds_list_create();
global.modelRendering = pr_trianglelist;

vertex_format_begin();
    
    vertex_format_add_position_3d();                                        // Vertex
    vertex_format_add_texcoord();                                           // Texture
    vertex_format_add_normal();                                             // Normal
    vertex_format_add_color();                                              // Diffuse color
    vertex_format_add_color();                                              // Ambient color
    vertex_format_add_color();                                              // Reflectivity color
    vertex_format_add_custom(vertex_type_float2, vertex_usage_colour );     // Alpha / Reflectivity value
    vertex_format_add_custom(vertex_type_float3, vertex_usage_tangent);     // Tangent
    vertex_format_add_custom(vertex_type_float3, vertex_usage_binormal);    // Bitangent
    
global.modelFormat = vertex_format_end();

#macro MQ_ERROR -1
#macro MQ_OK    +1
#endregion

#region Formats
vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_normal();
    vertex_format_add_color();
    vertex_format_add_textcoord();
global.VoxelFormat = vertex_format_end();

vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_textcoord();
    vertex_format_add_color();
    vertex_format_add_normal();
global.vft_simple_3d = vertex_format_end();

vertex_format_begin();
    vertex_format_add_position_3d();
global.vfBounds = vertex_format_end();
#endregion

draw_set_font(fRegular);

global.DEBUG = false;
global.TGABuffer = ds_map_create();
global.PNGBuffer = ds_map_create();
global.MODEL_BUFFER = ds_map_create();

enum eMode {
    Selection, 
    Transform, 
    Placing, 
    Drawing, 
    
    Count, 
    Any, 
};

global.MODE[eMode.Count] = false;
global.MODE[eMode.Any  ] = false;
