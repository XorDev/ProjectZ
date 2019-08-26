#ifdef __FRAGMENT_PRE_MAIN__
#undef __FRAGMENT_PRE_MAIN__

#define TEXTURE_INDEX(i) t##i
#define SAMPLER_INDEX(i) s##i

#define DIFFUSE_INDEX 0
#define SHADOWS_INDEX 1
#define BLNOISE_INDEX 2

Texture2D gm_BaseTextureObject  : register(TEXTURE_INDEX(0));
SamplerState gm_BaseTexture     : register(SAMPLER_INDEX(0));

Texture2D _DepthTexture         : register(TEXTURE_INDEX(1));
SamplerState _DepthSampler      : register(SAMPLER_INDEX(1));

Texture2D<float2> _NoiseTexture : register(TEXTURE_INDEX(2));
SamplerState _NoiseSampler      : register(SAMPLER_INDEX(2));

Texture2D _EmissionTexture      : register(TEXTURE_INDEX(3));
SamplerState _EmissionSampler   : register(SAMPLER_INDEX(3)) {
    BorderColor = float4(0., 0., 0., 0.);
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

#define StaticConst /*static const */

//struct Settings {
StaticConst bool _CelShading = true;
StaticConst bool _Tonemapping;
StaticConst bool _Fog;
StaticConst bool _FogHeight;
StaticConst bool _FogDistant;
StaticConst bool _Shadows = true;
StaticConst bool _RimLight;
    
    // Height based fog
StaticConst float _HFogNear;
StaticConst float _HFogHeight;
StaticConst float _HFogFalloff;
    
    // Distance based fog
StaticConst float _DFogStart;
StaticConst float _FogDensity;
    
    // Shadows
    
    
    // Cel-Shading
StaticConst float _CSSteps = 3.;
StaticConst float _CSStepsInv = 1. / 3.;
    
    // Rim-Light
StaticConst float _RLLowBound = .8;
    
    // HDR
StaticConst float _Exposure = 1.f;
//};

float1 _Far;
float2 _ShadowMapSize  = (2048.f).xx;
float2 _ShadowMapTexel = (1.f / 2048.f).xx;
float3 _SunDir;
float3 _CameraPos;
//Settings _Settings;

bool _Emission;

float _Selection, _Selected;

static const float3 _SkyColor = float3(.4, .5, .8);
static const float3 _SunColor = float3(.9, .8, .5);
static const float3 _FogColor = float3(.4, .4, .4);
static const float3 _FogHighlightColor = float3(.9, .8, .5);

#region Shadows
#region Float Packing/Unpacking
inline float vtof(float3 v) /*{ return v.r * 64000.; } //*/{ return v.r * 65536. + v.g * 256. + v.b; }
inline float3 ftov(float f) { return float3(floor(f / 256.) / 256., frac(f / 256.), frac(floor(f * 256.) / 256.)); }

inline float  unpack(float4 z0) { return vtof(z0.xyz) / 16.f; }
inline float3 pack  (float1 z0) { return ftov(z0 * 16.f); }
#endregion

float Shadow(float3 coord, float2 size, float2 bias, float LNdotD) {
    [branch] if( saturate(coord.x) == coord.x && saturate(coord.y) == coord.y || (LNdotD <= 0.)) {
        return 0.f;
    }
    
    // Calculate dx and dy based on Noise
    float2 fNoise = (_NoiseTexture.Sample(_NoiseSampler, coord.xy * 20.) * 2. - 1.) * 3.; // * .00625;
    float2 dx = float2(fNoise.x * _ShadowMapTexel.x, 0.);
    float2 dy = float2(0., fNoise.y * _ShadowMapTexel.y);
    float2 p_dxdy = (dx + dy);
    float2 n_dxdy = (dx - dy);
    
    // 
    float2 samples[8] = { dx, -dx, dy, -dy, p_dxdy, -p_dxdy, n_dxdy, -n_dxdy };
    
    // Gather noise
    float sDepth = 0.;
    
    [unroll(8)]
    for( int i = 0; i < 8; i++ ) 
        sDepth += ((unpack(_DepthTexture.Sample(_DepthSampler, coord.xy + samples[i])) - bias) > coord.z);
    
    return sDepth * .125 * LNdotD;
}
#endregion

#define length2(x) dot(x, x)

#region Fog
float FogHeight(float3 WP, float3 Color) {
    float3 eye2px = WP - _CameraPos;
    
    float pDist       = length(eye2px);
    float3 eye2pxNorm = eye2px / pDist;
    float fogDist     = max(pDist - _DFogStart, 0.);
    
    // fogHeightDensityAtViewer
    float fhdav    = exp(-_HFogFalloff * _CameraPos.z);
    float fDistInt = fogDist * fhdav;
    
    float e2py = eye2px.z * (fogDist / pDist);
    float t    = _HFogFalloff * e2py;
    
    const float thresholdT = .01;
    
    float fogHInt = abs(t) > thresholdT ? (1. - exp(-t)) / t : 1.;
    float fogFinal = exp(-_FogDensity * fDistInt * fogHInt);
    
    float sunHighlightF = pow(saturate(dot(eye2pxNorm, _SunDir)), 8.);
    
    float3 fogColor = lerp(_SkyColor, _FogHighlightColor, sunHighlightF);
    return lerp(fogColor, Color, fogFinal);
}

float FogHeight(float3 WP) {
    float dist = length2(WP - _CameraPos);
    float fog = _HFogFalloff * smoothstep(_SkyColor.b, _HFogNear, _HFogHeight - WP.z);
    
    return exp2(-dist * fog);
}
#endregion

// https://aras-p.info/texts/CompactNormalStorage.html#method03spherical
// Spherical Coordinates
#define kPI 3.1415926536f
half2 EncodeNormal(half3 n) {
    return half2(atan2(n.y, n.x) / kPI, n.z) * .5f + .5f;
}

struct HDRGBuffer {
    float4 LowBits  : SV_Target0; // RGB: HDR Diffuse Low  bits; A : Unused /* Debug mode req. A channel */
    float4 HighBits : SV_Target1; // RGB: HDR Diffuse High bits; A : Unused
    float4 Depth    : SV_Target2; // RGB: 24 bit depth buffer  ; A : Unused
    float4 Normal   : SV_Target3; // RG: Normal in Sphr coords ; BA: Unused
};

#endif

#ifdef __FRAGMENT_MAIN__
#undef __FRAGMENT_MAIN__

#if !defined(__CUSTOM_FUNCTION__) || (defined(__CUSTOM_FUNCTION__) && !defined(CUSTOM_FUNCTION))
HDRGBuffer main(PS In) 
#else
CUSTOM_FUNCTION
#endif
{
    // Diffuse
    float4 ResultDiffuse = Diffuse(In);
    
    // Lighting
    float t1 = max(.3, dot(In.Normal, _SunDir));
    [flatten] if( _CelShading ) {
        t1 = ceil(t1 * _CSSteps) * _CSStepsInv;
    }
    
    ResultDiffuse.rgb *= t1;
    
    // Rim lighting
    [flatten] if( _RimLight ) {
        float VdotN = smoothstep(_RLLowBound, 1., (1. - dot(-normalize(In.ViewPos), In.VNormal)));
        ResultDiffuse.rgb = lerp(ResultDiffuse.rgb, _SunColor, VdotN);
    }
    
    // Shadow mapping
    [flatten] if( _Shadows ) {
        float2 scoord = float2(In.LSCoord.x / In.LSCoord.z + 1., 3. - In.LSCoord.y / In.LSCoord.z) * .5;
        float t = Shadow(float3(scoord, In.LSCoord.z), _ShadowMapSize, 1., dot(In.LSNormal, _SunDir));
        
        ResultDiffuse.rgb = lerp(lerp(ResultDiffuse.rgb, _SkyColor, .4), 
                                 lerp(ResultDiffuse.rgb, _SunColor, .4), t);
    }
    
    // Fog
    [flatten] if( _Fog ) {
        // Height-based
        [flatten] if( _FogHeight ) {
            ResultDiffuse.rgb = lerp(ResultDiffuse.rgb, _FogColor, 1.f - FogHeight(In.WorldPos));
            //ResultDiffuse.rgb = FogHeight(In.WorldPos, ResultDiffuse.rgb);
        }
        
        // Distance-based
        [flatten] if( _FogDistant ) {
            float d = length(In.ViewPos) / _Far * 200. * _DFogStart;  // Distance
            float t = saturate(exp(-d * _FogDensity));                // Factor
            
            ResultDiffuse.rgb = lerp(_FogColor, ResultDiffuse.rgb, t);
        }
    }
    
    // Exposure
    ResultDiffuse.rgb *= _Exposure;
    
#ifndef __CUSTOM_OUTPUT__
    // HDR GBuffer
    HDRGBuffer Out;
        //Out.LowBits  = float4(fmod(ResultDiffuse.rgb, 1.f)           , _Selection);
        //Out.HighBits = float4(ResultDiffuse.rgb - Out.LowBits.rgb    , 1.);
        Out.LowBits  = float4(ResultDiffuse.rgb                                         , _Selection);
        Out.HighBits = float4(_EmissionTexture.Sample(_EmissionSampler, In.Texcoord).rgb, 1.);
        Out.Depth    = float4(pack(In.ViewPos.z)                                        , 1.);
        Out.Normal   = float4(EncodeNormal(In.Normal)                               , 0., 1.);
    return Out;
#else
    return CustomOutput(ResultDiffuse, In);
#endif
}
#endif
