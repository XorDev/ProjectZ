#include "shader3.shader"

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
    float4 WorldPos : TEXCOORD1;
    float4 Color    : COLOR0;
};

float4 _Clip;

float4 main(PS In) : SV_Target {
    clip( (In.WorldPos.xy >= _Clip.xy && In.WorldPos.xy <= _Clip.zw) ? 1. : -1. );
    
    return In.Color * gm_BaseTextureObject.Sample(gm_BaseTexture, In.Texcoord);
}
