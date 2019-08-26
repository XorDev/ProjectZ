/// @desc Renderer Setup
gpu_set_tex_repeat(true);
gpu_set_tex_mip_enable(mip_on);
gpu_set_tex_mip_filter(tf_anisotropic);
gpu_set_tex_max_aniso(16);
gpu_set_tex_filter(true);
gpu_set_tex_max_mip(5);
gpu_set_tex_min_mip(0);

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);

first = true;

// Models
//modelLandscape    = ModelLoad("Dunes1"      );
modelAlley        = ModelLoad("Alley"       );
modelTestSSDO     = ModelLoad("TestSSDO"    );
modelTestLevel2   = ModelLoad("TestLevel2"  );
modelCar          = ModelLoad("Car"         );
modelScifiCrate   = ModelLoad("SciFiCrate"  );
modelTerrainPatch = ModelLoad("TerrainPatch");
modelAxis         = ModelLoad("Axis"        );
modelGITest       = ModelLoad("GI Test"     );

// Car settings
fAngle = 0;

// 
enum eRenderFlags {
    Opaque      = 1, 
    Transparent = 2, 
    Depth       = 4, 
    SkyBox      = 8, 
    Terrain     = 16, 
    AnimatedMdl = 32, 
    Axis        = 64, 
    DontShow    = 128, 
    NoDepth     = 256, 
    ZWDisable   = 512, 
    
    
}

pass = eRenderFlags.Opaque;

// HDR pass
_ACES = shader_get_uniform(shHDR, "_ACES");

// SSDO passes
// Accumulation
_OcclusionMaxDistance            = shader_get_uniform(shSSDOAccumulate, "_OcclusionMaxDistance");
_OcclusionRadius                 = shader_get_uniform(shSSDOAccumulate, "_OcclusionRadius");
_InvResolution[shSSDOAccumulate] = shader_get_uniform(shSSDOAccumulate, "_InvResolution");
_NoiseSize                       = shader_get_uniform(shSSDOAccumulate, "_NoiseSize");
_mInvProj[shSSDOAccumulate]      = shader_get_uniform(shSSDOAccumulate, "_mInvProj");
_mInvView[shSSDOAccumulate]      = shader_get_uniform(shSSDOAccumulate, "_mInvView");

// Blur pass
_InvResolution[shSSDOAccumulationBlur] = shader_get_uniform(shSSDOAccumulationBlur, "_InvResolution");
_Direction                             = shader_get_uniform(shSSDOAccumulationBlur, "_Direction");

// Resolve
_Time                         = shader_get_uniform(shSSDOResolve, "_Time");
_InvResolution[shSSDOResolve] = shader_get_uniform(shSSDOResolve, "_InvResolution");
_mInvProj[shSSDOResolve]      = shader_get_uniform(shSSDOResolve, "_mInvProj");
_mInvView[shSSDOResolve]      = shader_get_uniform(shSSDOResolve, "_mInvView");
_mViewProjInv                 = shader_get_uniform(shSSDOResolve, "_mViewProjInv");
_CameraPos[shSSDOResolve]     = shader_get_uniform(shSSDOResolve, "_CameraPos");

_LightPos   = shader_get_uniform(shSSDOResolve, "_LightPos"  );
_LightCol   = shader_get_uniform(shSSDOResolve, "_LightCol"  );
_LightCount = shader_get_uniform(shSSDOResolve, "_LightCount");

gLightIndex = 0;
gLightList_Pos = [];
gLightList_Col = [];

_mInvProj[shSSGI] = shader_get_uniform(shSSGI, "_mInvProj");
_mProj[shSSGI]    = shader_get_uniform(shSSGI, "_mProj");
_mView[shSSGI]    = shader_get_uniform(shSSGI, "_mView");
_Far[shSSGI]      = shader_get_uniform(shSSGI, "_Far");

_GIStrength = shader_get_uniform(shSSGI, "_GIStrength");
_GIMaxSteps = shader_get_uniform(shSSGI, "_GIMaxSteps");
_GIRayStep  = shader_get_uniform(shSSGI, "_GIRayStep");


// 
enum eModelItem {
    Model, 
    Rotation, 
    Scale, 
    Position, 
    Flags, 
    External0, 
    
    
}

ModelLastIndex = 0;
ModelList[255] = 0;

// Debug
Selection = -1;
sDebugBuffer = buffer_create(WIDTH * HEIGHT * 4, buffer_fast, 1);

TargetTransform = [0, 0, 0];
Transformed = true;

enum eTransformFlags {
    Position = 1, 
    Relative = 2, 
    
}

// 
gSplatMap     = GenBuffer(noone, 2048, 2048);
gPatchGrid    = ds_grid_create(10, 10);
gPatchList    = ds_list_create();
gChannelIndex = 0;
gBrushSize    = 16;
gMousePoint   = -1;

// Collisions
//colmesh_init();
//global.mCollisionBuffer = buffer_create(1024 * 1024 * 2, buffer_grow, 1);
gUpdateCollisions = false;
gUpdateCollisionsData = -1;
gUpdateCollisionsF = 0;
//colmesh_destroy();

// 
ZGridWidth  = 1024;
ZGridHeight = 1024;

ZGrid = ds_grid_create(ZGridWidth, ZGridHeight);

// Main scene
PlaceModel(modelGITest, [90, 0, 0], [100, 100, 100], [0, 0, 0], 0);

//PlaceModel(modelAlley     , [0, 0, 0], [100, 100, 100], [0*4000 + 0000, 0, 0], 0);
//PlaceModel(modelTestLevel2, [0, 0, 0], [100, 100, 100], [0*4000 + 2000, 0, 0], 0);
//PlaceModel(modelTestSSDO  , [0, 0, 0], [100, 100, 100], [0*4000 + 4000, 0, 0], 0);

#region
/*PlaceModel(modelTerrainPatch, [0, 0, 0], [1000, 1000, 1000], [0, 0, 0], eRenderFlags.Terrain, 
[
    // Textures
    [
        sprDiffuse0, 
        sprDiffuse1, 
        sprDiffuse2, 
        gSplatMap
    ], 
    
    // Offsets
    [
        0, 0, .5, .5
    ]
]);

gPatchGrid[# 4, 4] = ModelLastIndex - 1;
ds_list_add(gPatchList, ModelLastIndex - 1, [4, 4]);

PlaceModel(modelTerrainPatch, [0, 0, 0], [1000, 1000, 1000], [0, 2000, 0], eRenderFlags.Terrain, 
[
    // Textures
    [
        sprDiffuse0, 
        sprDiffuse1, 
        sprDiffuse2, 
        gSplatMap
    ], 
    
    // Offsets
    [
        0, .5, .5, 1
    ]
]);

gPatchGrid[# 4, 5] = ModelLastIndex - 1;
ds_list_add(gPatchList, ModelLastIndex - 1, [4, 5]);

PlaceModel(modelTerrainPatch, [0, 0, 0], [1000, 1000, 1000], [2000, 0, 0], eRenderFlags.Terrain, 
[
    // Textures
    [
        sprDiffuse0, 
        sprDiffuse1, 
        sprDiffuse2, 
        gSplatMap
    ], 
    
    // Offsets
    [
        .5, 0, 1, .5
    ]
]);

gPatchGrid[# 5, 4] = ModelLastIndex - 1;
ds_list_add(gPatchList, ModelLastIndex - 1, [5, 4]);

PlaceModel(modelTerrainPatch, [0, 0, 0], [1000, 1000, 1000], [2000, 2000, 0], eRenderFlags.Terrain, 
[
    // Textures
    [
        sprDiffuse0, 
        sprDiffuse1, 
        sprDiffuse2, 
        gSplatMap
    ], 
    
    // Offsets
    [
        .5, .5, 1, 1
    ]
]);*/

gPatchGrid[# 5, 5] = ModelLastIndex - 1; //*/
ds_list_add(gPatchList, ModelLastIndex - 1, [5, 5]);

#endregion

PlaceModel(modelAxis, [0, 0, 0], [100, 100, 100], [0, 0, 0], eRenderFlags.DontShow | eRenderFlags.Axis | eRenderFlags.NoDepth | eRenderFlags.ZWDisable);
mAxisID = ModelLastIndex - 1;

// Car z in alley scene
// zMax = .200348

// Uniforms
UniformInit(shRenderModel);
UniformInit(shRenderModelAxis);
UniformInit(shTerrainSplat);
UniformInit(shRenderModelDepth);

// Buffers
rtLight   = noone;
rtHDR0    = noone;
rtHDR1    = noone;
rtDepth   = noone;
rtNormal  = noone;
rtSSDOAcc = noone;
rtSSDOBlr = noone;
rtSSDOBr2 = noone;
rtSSDORes = noone;

// HDR Adaptation cycles
HDRCycles = 4;
HDRDel = (1. / (HDRCycles + 1.));
rtHDRAvg[HDRCycles] = noone;
rtHDRAvgCurr        = noone;
for( var i = 0; i < HDRCycles; i++ ) {
    rtHDRAvg[HDRCycles - 1 - i] = noone;
}


// VPL
vplTarget0 = vplCreateTarget(16, 16, 4, 4, 4, 0, 0, 0, 64);



// UI
FancyFlags = uiFlags.RoundRect | uiFlags.Fancy;
uiInit();

uiBegin();
    uipDebug = uiPanelBegin("Debug", WIDTH / 3, HEIGHT, 0, 0);
        uiTabSpaceBegin(0);
            uiTabBegin("Graphics Settings");
                uiScrollBegin(uiFlags.Ver | FancyFlags);
                    bvHDR = uiAddCheckBox("HDR Renderer", true, FancyFlags | uiFlags.Inactive);
                    bvACES = uiAddCheckBox("ACES", true, FancyFlags);
                    bvEyeAdaptation = uiAddCheckBox("Eye adaptation", true, FancyFlags | uiFlags.Inactive);
                    
                    fvExposure = uiAddFloat("Exposure", .5, 0, 2);
                    
                    bvCelShading = uiAddCheckBox("Cel-Shading", true, FancyFlags);
                        fvCSSteps = uiAddInt("Steps", 3 / 10, 1, 10);
                    
                    bvTonemapping = uiAddCheckBox("Tonemapping", false, FancyFlags | uiFlags.Inactive);
                        uiAddButton("Load tonemap", __funcLoadTonemap, FancyFlags | uiFlags.Inactive);
                        flTonemaps = uiFelloutListBegin("Tonemaps", 0, noone, uiFlags.Inactive);
                            uiAddFelloutItem("None");
                            uiAddFelloutItem("Default");
                        uiFelloutListEnd();
                    
                    bvFog = uiAddCheckBox("Fog", true, FancyFlags);
                        bvFogHeight  = uiAddCheckBox("Height Based", false, FancyFlags | uiFlags.Inactive);
                            fvFogNear    = uiAddFloat("Near"   , .35, 0, 1 , uiFlags.Inactive);
                            fvFogHeight  = uiAddFloat("Height" , 0  , 0, 20, uiFlags.Inactive);
                            fvFogFalloff = uiAddFloat("Falloff", 1  , 0, 1 , uiFlags.Inactive); // .0125
                            
                        bvFogDistant = uiAddCheckBox("Distant", true, FancyFlags);
                            fvFogStart   = uiAddFloat("Start", 3 / 5, 0, 5);
                            fvFogDensity = uiAddFloat("Density", .2, 0, 2.);
                            
                    bvRimLight = uiAddCheckBox("Rim-Light", true, FancyFlags);
                        fvRLLowBound = uiAddFloat("Low bound", .8, 0, 1.);
                    
                    bvShadows = uiAddCheckBox("Shadows", true, FancyFlags);
                    bvDSSDO    = uiAddCheckBox("SSDO", false, FancyFlags | uiFlags.Inactive);
                        fvOccDist = uiAddFloat("Occlusion max distance", .3 , 0, 1, uiFlags.Inactive);
                        fvOccRad  = uiAddFloat("Occlusion radius"      , .02, 0, 1, uiFlags.Inactive);
                    
                    bvSSAO = uiAddCheckBox("SSAO", FancyFlags | uiFlags.Inactive);
                    
                    bvSSGI = uiAddCheckBox("SSGI", false, FancyFlags);
                    GIStrength = uiAddFloat("GI Strength", .1, 0, 2);
                    GIRayStep  = uiAddFloat("GI RayStep" , .1, 0, 2);
                    GIMaxSteps = uiAddInt(  "GI MaxSteps",  1, 0, 5);
                    
                    bvBakeVPL = uiAddCheckBox("Bake VPL", false, uiFlags.Inactive);
                    
                    uiAddText("Padding :D");
                    repeat(5) uiAddSeparator();
                uiScrollEnd();
            uiTabEnd();
            
            //uiTabBegin("Colors");
            //    csSky = uiAddColorSelector("Sky color", uiFlags.CSPoint1 | uiFlags.CSCircle);
            //    csFog = uiAddColorSelector("Fog color", uiFlags.CSPoint1 | uiFlags.CSCircle);
            //    
            //    bvColors = uiAddCheckBox("Use custom colors", false, FancyFlags);
            //uiTabEnd();
            
            uiTabBegin("Transform");
                csTransformType = uiChooseSpaceBegin(0, "Transformation type", FancyFlags);
                    uiAddChoose("Move");
                    uiAddChoose("Rotate");
                    uiAddChoose("Scale");
                uiChooseSpaceEnd();
                
                flObjects = uiFelloutListBegin("Objects");
                    uiAddFelloutItem("Noone");
                    uiAddFelloutItem("Car");
                uiFelloutListEnd();
                
                bvGrid  = uiAddCheckBox("Grid", true, FancyFlags);
                bvAlign = uiAddCheckBox("Align with grid", true, FancyFlags);
                fvGridA = uiAddFloat("Grid alpha", .2, 0, 1);
                
                csGridSize = uiChooseSpaceBegin(0, "Grid size", FancyFlags);
                    uiAddChoose("1");
                    uiAddChoose("8");
                    uiAddChoose("16");
                    uiAddChoose("32");
                    uiAddChoose("64");
                    uiAddChoose("128");
                uiChooseSpaceEnd();
            uiTabEnd();
            uiTabBegin("Keybindings");
                uiAddText("Alt - Object Selection");
                uiAddText("Ctrl - Object Placing");
                uiAddText("Alt + Ctrl - Object Transformation");
                uiAddText("[Alt] + Shift - Brush for splat map");
                uiAddText("LMB, WASD, QE - Object transformation");
                
                uiAddSeparator();
                uiAddText("Space - Set directional light");
                uiAddText("F3 - Toggle debug menu");
                uiAddText("Shift + Up - Fullscreen");
                uiAddText("Shift + Down - 1024x540");
                
            uiTabEnd();
        uiTabSpaceEnd();
    uiPanelEnd();
ui = uiEnd();

// Temp preset
uiSetValue(bvShadows   , false);
uiSetValue(bvACES      , false);
uiSetValue(bvFog       , false);
uiSetValue(bvRimLight  , false);
uiSetValue(bvCelShading, false);
