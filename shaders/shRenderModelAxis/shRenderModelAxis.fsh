#define __VERTEX_DISABLE__
#define __FRAGMENT_PRE_MAIN__
#include "shMainRenderer.shader"

inline float4 Diffuse(PS In) {
    float4 ResultDiffuse = gm_BaseTextureObject.Sample(gm_BaseTexture, In.Texcoord);
    [branch] if( ResultDiffuse.a < .5 ) { discard; }
    return ResultDiffuse;
}

inline float4 CustomOutput(float4 ResultDiffuse, PS In) {
    return float4(ResultDiffuse.rgb, _Selection);
}

#define CUSTOM_FUNCTION float4 main(PS In) : SV_Target0 

#define __CUSTOM_FUNCTION__ // For CUSTOM_FUNCTION
#define __CUSTOM_OUTPUT__   // For CustomOutput
#define __FRAGMENT_MAIN__
#include "shMainRenderer.shader"

