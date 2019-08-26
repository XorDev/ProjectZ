#include "shader3.shader"

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
};

float _cwType;
/*static const float M_PI = 3.14;
static const float angle = (-0. * M_PI) / 180.;
static const float2x2 m_Rot = float2x2(cos(angle), -sin(angle), //0, 
                                       sin(angle), +cos(angle)/*, 0, 
                                       0         , 0          , 1* /);*/

float4 main(PS In) : SV_Target {
    //In.Texcoord = mul(m_Rot, In.Texcoord);
    float3 val;
    
    // r--?
    // |  |
    // b--g
    float a = 1.;
    
    if( _cwType == 1. ) {
        // It's an a circle, not a disc
        val = float3(1. - In.Texcoord, In.Texcoord.y);
        a = float(distance(In.Texcoord, .5.xx) > .357);
    } else {
        // It's an a rectangle
        val = float3(1. - In.Texcoord, 0.); // hsv2rgb
    }
    
    return float4(val, a);
}
