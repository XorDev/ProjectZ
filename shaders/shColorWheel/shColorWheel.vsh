#include "shader2.shader"

struct VS {
    float4 Position : POSITION;
    float2 Texcoord : TEXCOORD0;
};

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
};

PS main(VS In) {
    PS Out;
        Out.Position = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], In.Position);
        Out.Texcoord = In.Texcoord;
    return Out;
}
