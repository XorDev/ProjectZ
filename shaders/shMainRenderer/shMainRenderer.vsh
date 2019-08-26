#ifndef __VERTEX_DISABLE__
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
    float3 Normal   : NORMAL0;
};

struct PS {
    float4 Position : SV_Position0;
    float3 Normal   : NORMAL0;
    float3 LSNormal : NORMAL1;
    float3 VNormal  : NORMAL2;
    float2 Texcoord : TEXCOORD0;
    float3 LSCoord  : TEXCOORD1;
    float3 WorldPos : TEXCOORD2;
    float3 ViewPos  : TEXCOORD3;
};

float4x4 _LightMatrix;

PS main(VS In) {
    float4 WN = mul(gm_Matrices[MATRIX_WORLD], float4(In.Normal, 0.));
    float4 WP = mul(gm_Matrices[MATRIX_WORLD], In.Position);
    float4 VP = mul(gm_Matrices[MATRIX_VIEW], WP);
    float4 LP = mul(_LightMatrix, WP);
    float4 LN = mul(_LightMatrix, WN);
    
    PS Out;
        Out.LSCoord  = LP.xyz;
        Out.WorldPos = WP.xyz;
        Out.ViewPos  = VP.xyz;
        Out.LSNormal = -normalize(LN.xyz);
        Out.Normal   =  normalize(WN.xyz);
        Out.VNormal  = normalize(mul(gm_Matrices[MATRIX_VIEW], WN).xyz);
        Out.Position = mul(gm_Matrices[MATRIX_PROJECTION], VP);
        Out.Texcoord = float2(In.Texcoord.x, -In.Texcoord.y);
    return Out;
}
#endif
