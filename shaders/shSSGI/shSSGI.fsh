Texture2D _NormalBuffer   : register(t0);
SamplerState _NormalSampl : register(s0);

Texture2D _DepthBuffer     : register(t1);
SamplerState _DepthSampler : register(s1);

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
    float3 ViewRay  : TEXCOORD1;
};

// 
float4x4 _mProj, _mView;
//float2 _CamProj;
float1 _Far;

float _GIStrength;
float _GIRayStep;
uint  _GIMaxSteps;

// 
static const float AngleMix = .5f;
static const float Strength = 2.f * 1.f / (_GIStrength);

// https://aras-p.info/texts/CompactNormalStorage.html#method03spherical
// Spherical Coordinates
#define kPI 3.1415926536f
half3 NormalDecode(half2 enc) {
    half2 scth, ang = enc * 2.f - 1.f;
    sincos(ang.x * kPI, scth.x, scth.y);

    half2 scphi = half2(sqrt(1.f - ang.y * ang.y), ang.y);
    return half3(scth.y * scphi.x, scth.x * scphi.x, scphi.y);
}

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
    return NormalDecode(_NormalBuffer.Sample(_NormalSampl, uv).rg);
}

// 
float2 GetProjected(float3 hit) {
    float4 p = mul(_mProj, float4(hit, 1.f));
           p.xy = p.xy / p.w * .5f + .5f;
    
    return float2(p.x, 1.f - p.y);
}

float GetDeltaD(float3 hit, float3 ViewRay) {
    float2 uv    = GetProjected(hit);
    float1 depth = SampleDepth(uv);
    float3 p = ViewRay * depth;
    
    return p.z - hit.z;
}

float RayCast(float3 Start, float3 dir, float3 ViewRay) {
    float3 hit = Start;
    dir *= _GIRayStep * 2.f;
    
    float dist = .15f;
    [unroll(5)] for( uint i = 0; i < _GIMaxSteps; i++ ) {
        hit += dir;
        float dt = GetDeltaD(hit, ViewRay);
        
        [flatten] if( dt > 0.f && dt < .2f ) { dist = distance(Start, hit); return dist; }
    }
    
    return dist;
}

float3 tangent(float3 N) {
    float3 t1 = cross(N, float3(0.f, 0.f, 1.f));
    float3 t2 = cross(N, float3(0.f, 1.f, 0.f));
    
    float l1 = length(t1);
    float l2 = length(t2);
    
    if( l1 > l2 ) return t1 / l1; else return t2 / l2;
}

float4 main(PS In) : SV_Target0 {
    //float4 Out = gm_BaseTextureObject.Sample(gm_BaseTexture, In.Texcoord);
    float4 Out = 0.f;
    
    float3 N = SampleNormal(In.Texcoord);
    float1 D = SampleDepth(In.Texcoord);
    
    float3 V = In.ViewRay * D;
    
    float r = RayCast(V, N, In.ViewRay);
    
    float3 o1 = normalize(tangent(N));
    float3 o2 = cross(o1, N);
    float3 c1 = .5f * (o1 + o2);
    float3 c2 = .5f * (o1 - o2);
    
    r += RayCast(V, lerp(N, +o1, AngleMix), In.ViewRay);
    r += RayCast(V, lerp(N, +o2, AngleMix), In.ViewRay);
    r += RayCast(V, lerp(N, -c1, AngleMix), In.ViewRay);
    r += RayCast(V, lerp(N, -c2, AngleMix), In.ViewRay);
    
    return float4(r.xxx * 1.f, 1.f);
}
