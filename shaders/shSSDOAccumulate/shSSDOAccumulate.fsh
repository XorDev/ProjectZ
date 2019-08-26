#region Points
static const int num_samples = 32;

static const float3 points[] = {
	float3(-0.134, 0.044, -0.825),
	float3(0.045, -0.431, -0.529),
	float3(-0.537, 0.195, -0.371),
	float3(0.525, -0.397, 0.713),
	float3(0.895, 0.302, 0.139),
	float3(-0.613, -0.408, -0.141),
	float3(0.307, 0.822, 0.169),
	float3(-0.819, 0.037, -0.388),
	float3(0.376, 0.009, 0.193),
	float3(-0.006, -0.103, -0.035),
	float3(0.098, 0.393, 0.019),
	float3(0.542, -0.218, -0.593),
	float3(0.526, -0.183, 0.424),
	float3(-0.529, -0.178, 0.684),
	float3(0.066, -0.657, -0.570),
	float3(-0.214, 0.288, 0.188),
	float3(-0.689, -0.222, -0.192),
	float3(-0.008, -0.212, -0.721),
	float3(0.053, -0.863, 0.054),
	float3(0.639, -0.558, 0.289),
	float3(-0.255, 0.958, 0.099),
	float3(-0.488, 0.473, -0.381),
	float3(-0.592, -0.332, 0.137),
	float3(0.080, 0.756, -0.494),
	float3(-0.638, 0.319, 0.686),
	float3(-0.663, 0.230, -0.634),
	float3(0.235, -0.547, 0.664),
	float3(0.164, -0.710, 0.086),
	float3(-0.009, 0.493, -0.038),
	float3(-0.322, 0.147, -0.105),
	float3(-0.554, -0.725, 0.289),
	float3(0.534, 0.157, -0.250),
};
#endregion

Texture2D _NoiseTexture  : register(t0);
SamplerState _NoiseSampl : register(s0);

Texture2D _DepthBuffer     : register(t1);
SamplerState _DepthSampler : register(s1);

Texture2D _NormalBuffer     : register(t2);
SamplerState _NormalSampler : register(s2);

float _OcclusionMaxDistance, _OcclusionRadius;
float2 _NoiseSize, _InvResolution;
float4x4 _mInvProj, _mInvView;

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
    float3 cPos   = normalize(GetWorldPos(In.Texcoord));
    float3 EyePos = _mInvView[3].xyz;
    
    float cDepth = distance(EyePos, cPos);
    
    // 
    float r          = _OcclusionRadius / cDepth; // Radius
    float InvMaxDist = 1. / _OcclusionMaxDistance; // Give already inv value
    float attAngT    = .1;
    
    // 
    float3 Noise   = _NoiseTexture.Sample(_NoiseSampl, In.Texcoord * _InvResolution * _NoiseSize).rgb * 2. - 1.;
    float3 cNormal = SampleNormal(In.Texcoord);
    
    float4 OccSH2 = 0.;
    
    // Constants
    const float fl0 = 2.;
    const float fl1 = 10.;
    
    const float  wl0 = fl0 * .28209; // .5 * sqrt(1. / pi)
    const float3 wl1 = fl1 * .48860; // .5 * sqrt(3. / pi)
    
    const float4 sh2w = float4(wl1, wl0) / num_samples;
    
    // 
    [unroll] for( int i = 0; i < num_samples; i++ ) {
        float2 offset = reflect(points[i].xy, Noise.xy).xy * r;
        
        float2 uv  = In.Texcoord + offset;
        float3 pos = normalize(GetWorldPos(uv));
        float3 c2s = pos - cPos;
        
        float dist = length(c2s);
        
        float3 c2sN = c2s / dist;
        
        float att = 1. - saturate(dist * InvMaxDist);
        float dp = dot(cNormal, c2sN);
        
        att = att * att * step(attAngT, dp);
        
        OccSH2 += att * sh2w * float4(c2sN, 1.);
    }
    
    return normalize(OccSH2) * .5 + .5;
}
