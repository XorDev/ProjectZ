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
#endif
#endregion

struct VS {
    float4 Position : POSITION0;
    float2 Texcoord : TEXCOORD0;
};

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
    float3 ViewRay  : TEXCOORD1;
};

float4x4 _mInvProj;

PS main(VS In) {
    // 
    float4 v = mul(_mInvProj, float4(In.Position.xy, 0.f, 1.f));
    
    PS Out;
        Out.Position = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], In.Position);
        Out.Texcoord = In.Texcoord;
        Out.ViewRay  = float3(v.xy / v.z, 1.f);
    return Out;
}
