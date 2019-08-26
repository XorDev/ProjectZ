Texture2D _OcclusionTexture    : register(t0);
SamplerState _OcclusionSampler : register(s0);

Texture2D _NormalBuffer        : register(t1);
SamplerState _NormalSampler    : register(s1);

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
};

static const float indices[9] = {-4, -3, -2, -1, 0, +1, +2, +3, +4};

float2 _InvResolution, _Direction;

// https://aras-p.info/texts/CompactNormalStorage.html#method03spherical
// Spherical Coordinates
#define kPI 3.1415926536f
float3 NormalDecode(float2 enc) {
    float2 scth, ang = enc * 2.f - 1.f;
    sincos(ang.x * kPI, scth.x, scth.y);
    
    float2 scphi = float2(sqrt(1.f - ang.y * ang.y), ang.y);
    return float3(scth.y * scphi.x, scth.x * scphi.x, scphi.y);
}

inline float3 SampleNormal(float2 uv) {
    return NormalDecode(_NormalBuffer.Sample(_NormalSampler, uv).rg);
}

float4 main(PS In) : SV_Target0 {
    float weights[9] = {
    	.013519569015984728,
    	.047662179108871855,
    	.11723004402070096,
    	.20116755999375591,
    	.240841295721373,
    	.20116755999375591,
    	.11723004402070096,
    	.047662179108871855,
    	.013519569015984728
    };
    
    float2 step = _Direction * _InvResolution;
    
    float3 N[9];
    [unroll] for( int i = 0; i < 9; i++ ) N[i] = SampleNormal(In.Texcoord + indices[i] * step);
    
    float w = 1.;
	float T = .85;
    
    [unroll] for( int i = 0; i < 9; i++ ) {
        if( dot(N[i], N[4]) < T ) {
            w -= weights[i];
            weights[i] = 0;
        }
    }
    
    float4 Out = 0.;
    
    [unroll] for( int i = 0; i < 9; i++ ) {
        Out += _OcclusionTexture.Sample(_OcclusionSampler, In.Texcoord + indices[i] * step) * weights[i] * 2. - 1.;
    }
    
    return float4(Out.rgb, 1.);
    
    return Out / w;
}
