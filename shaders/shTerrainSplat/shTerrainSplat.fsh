#define __VERTEX_DISABLE__
#define __FRAGMENT_PRE_MAIN__
#include "shMainRenderer.shader"

Texture2D    _SplatTexture0 : register(t4);
SamplerState _SplatSampler0 : register(s4);

Texture2D    _SplatTexture1 : register(t5);
SamplerState _SplatSampler1 : register(s5);

Texture2D    _SplatTexture2 : register(t6);
SamplerState _SplatSampler2 : register(s6);

Texture2D    _SplatTextureF : register(t7);
SamplerState _SplatSamplerF : register(s7);

inline float4 Diffuse(PS In) {
    float2 uv = frac(In.Texcoord);
    
    float3 f = _SplatTextureF.Sample(_SplatSamplerF, uv);
    
    float3 t0 = _SplatTexture0.Sample(_SplatSampler0, uv);
    float3 t1 = _SplatTexture1.Sample(_SplatSampler1, uv);
    float3 t2 = _SplatTexture2.Sample(_SplatSampler2, uv);
    
    return float4(t0 * f.r + t1 * f.g + t2 * f.b, 1.);
}

#define __FRAGMENT_MAIN__
#include "shMainRenderer.shader"

