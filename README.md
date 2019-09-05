# ProjectZ
3D collaborative project in GMS 2.

# SweetLuna's Graphics Pipeline
# Setting up shader environment
To run shaders you **MUST** do some env. setup for it.

1. I use runtime-2.2.3.344

2. Go to: C:\ProgramData\GameMakerStudio2\Cache\runtimes\runtime-2.2.3.344\bin\Shaders

2.1. Rename **HLSL11_PShaderCommon.shader** into **HLSL11_PShaderCommon.shader1**

2.2. Make empty file with name: **HLSL11_PShaderCommon.shader**

2.3. Repeat same for HLSL11_VShaderCommon.shader

If you want to collaborate to this project, you must change default shaders for a little:

1. Go to your GMS 2 installation directory

2. default

3. Make copies for two files: **fshader.txt** and **vshader.txt**

4.1. Replace content for **fshader.txt**

```hlsl
Texture2D gm_BaseTextureObject : register(t0);
SamplerState gm_BaseTexture    : register(s0);

cbuffer gm_PSMaterialConstantBuffer
{
	bool   gm_PS_FogEnabled;
	float4 gm_FogColour;
	bool   gm_AlphaTestEnabled;
	float4 gm_AlphaRefValue;
};

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
};

float4 main(PS In) : SV_Target0 {
    float4 Out = gm_BaseTextureObject.Sample(gm_BaseTexture, In.Texcoord);
    
    return Out;
}
```

4.2. Replace content for **vshader.txt**

```hlsl
#region Just delete it
#ifndef MATRIX_VIEW
#define	MATRIX_VIEW                  0
#define	MATRIX_PROJECTION            1
#define	MATRIX_WORLD                 2
#define	MATRIX_WORLD_VIEW            3
#define	MATRIX_WORLD_VIEW_PROJECTION 4
#define	MATRICES_MAX                 5 
#define	MAX_VS_LIGHTS                8

cbuffer gm_VSTransformBuffer
{
	float4x4 gm_Matrices[MATRICES_MAX];
};

cbuffer gm_VSMaterialConstantBuffer
{
	bool  gm_LightingEnabled;
	bool  gm_VS_FogEnabled;
	float gm_FogStart;
	float gm_RcpFogRange;
};

cbuffer gm_VSLightingConstantBuffer
{
	float4 gm_AmbientColour;                    // rgb=colour, a=1
	float3 gm_Lights_Direction[MAX_VS_LIGHTS];  // normalised direction
	float4 gm_Lights_PosRange [MAX_VS_LIGHTS];  // X,Y,Z position,  W range
	float4 gm_Lights_Colour   [MAX_VS_LIGHTS];  // rgb=colour, a=1
};
#endif
#endregion

struct VS {
    float4 Position : POSITION0;
    float2 Texcoord : TEXCOORD0;
};

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
};

PS main(VS In) {
    PS Out;
        Out.Position = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], In.Position);
        Out.Texcoord = In.Texcoord;
    return Out;
}
```

**You even don't need to restart IDE for this tricks**

# Graphics Pipeline has:
 * Unified rendering shaders
 * Dynamic Shadows
 * VPL / Backed GI (WIP)
 * Height Based Fog (WIP)
 * Distant Fog
 * Rim-Lighting
 * Cel-Shading
 * Post Processing
 * ACES Tonemapping
 * HDR?.. (512 gradations for each channel)
 * Deferred rendering (Multiple lights WIP)
 * Unified scene rendering
 * Flags for rendering each object
 * OBJ and MTL Loader with TGA/PNG/JPG support
 * DSSDO (WIP)
 * Eye adaptation (WIP)
 * Debug GUI
 * Basic object manipulation (WIP)
 * Splatmap support
 
 
 
