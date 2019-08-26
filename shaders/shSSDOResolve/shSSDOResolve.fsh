Texture2D _OcclusionTexture    : register(t0);
SamplerState _OcclusionSampler : register(s0);

Texture2D _DepthBuffer     : register(t1);
SamplerState _DepthSampler : register(s1);

Texture2D _NormalBuffer     : register(t2);
SamplerState _NormalSampler : register(s2);

float _Time;
float2 _InvResolution;
float3 _CameraPos;
float4x4 _mInvProj, _mInvView;

#define MAX_LIGHTS 10
float3 _LightPos[MAX_LIGHTS];
float3 _LightCol[MAX_LIGHTS];
float1 _LightCount;

// Screen space to World Space
float3 GetWorldPos(float2 uv, float z) {
    float4 p = float4(uv.x * 2. - 1., 1. - 2. * uv.y, z, 1.);
    p = mul(_mInvProj, p);
    p /= p.w;
    p = mul(_mInvView, p);
    return p.xyz;
}

// https://aras-p.info/texts/CompactNormalStorage.html#method03spherical
// Spherical Coordinates
#define kPI 3.1415926536f
half3 NormalDecode(half2 enc) {
    half2 scth, ang = enc * 2.f - 1.f;
    sincos(ang.x * kPI, scth.x, scth.y);

    half2 scphi = half2(sqrt(1.f - ang.y * ang.y), ang.y);
    return half3(scth.y * scphi.x, scth.x * scphi.x, scphi.y);
}

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
    float3 CamVec   : TEXCOORD1;
};


#region Float Packing/Unpacking
inline float vtof(float3 v) /*{ return v.r * 64000.; } //*/{ return v.r * 65536. + v.g * 256. + v.b; }
inline float3 ftov(float f) { return float3(floor(f / 256.) / 256., frac(f / 256.), frac(floor(f * 256.) / 256.)); }

inline float  unpack(float4 z0) { return vtof(z0.xyz) / 16.f; }
inline float3 pack  (float1 z0) { return ftov(z0 * 16.f); }
#endregion

inline float SampleDepth(float2 uv) {
    return unpack(_DepthBuffer.Sample(_DepthSampler, uv));
}

inline float3 SampleNormal(float2 uv) {
    return NormalDecode(_NormalBuffer.Sample(_NormalSampler, uv).rg);
}

inline float3 GetWorldPos(float2 uv) {
    return GetWorldPos(uv, SampleDepth(uv));
}

float4 main(PS In) : SV_Target0 {
    //[branch] if( _LightCount < 1 ) { return float4(0., 0., 0., 1.); }
    
    float3 WorldPos  = SampleDepth(In.Texcoord) * In.CamVec + _CameraPos;
    
    float3 Diffuse   = 1.;
    float3 Position  = GetWorldPos(In.Texcoord);
    float3 Normal    = SampleNormal(In.Texcoord);
    float4 Occlusion = _OcclusionTexture.Sample(_OcclusionSampler, In.Texcoord) * 2. - 1.;
    float3 Lighting  = 0.;
    
    //return float4(normalize(WorldPos) * .5 + .5, 1.);
    /*float lr = 2.;
    
    float3 plPos[] = {
        float3(lr * sin(_Time + 0.), lr * cos( _Time + 0.), 1.), 
        float3(lr * sin(_Time + 1.), lr * cos(-_Time + 2.), 1.), 
        float3(lr * sin(_Time + 2.), lr * cos(-_Time + 1.), 1.)
    };
    
    float3 plCol[] = {
        2. * float3(1 , .2, .2), 
        2. * float3(.2, 1 , .2), 
        2. * float3(.2, .2, 1 )
    };*/
    
    [unroll(MAX_LIGHTS)] for( int i = 0; i < min(_LightCount, MAX_LIGHTS); i++ ) {
        float3 p    = (_LightPos[i]);
        float3 toL  = Position - p;
        float  dist = length(toL);
        float3 toLN = toL / dist;
        float  lOcc = saturate(dot(float4(toLN, 1.), Occlusion));
        
        float distAtt = 1. / (1. + dist * dist);
        float ndl = max(0, dot(Normal, toLN));
        
        Lighting += _LightCol[i] * lOcc * ndl;// * distAtt;
    }
    
    return float4(Lighting * Diffuse, 1.);
}
