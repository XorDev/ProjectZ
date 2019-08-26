#define __VERTEX_DISABLE__
#define __FRAGMENT_PRE_MAIN__
#include "shMainRenderer.shader"

inline float4 Diffuse(PS In) {
    float4 ResultDiffuse = gm_BaseTextureObject.Sample(gm_BaseTexture, In.Texcoord);
    [branch] if( ResultDiffuse.a < .5 ) { discard; }
    return ResultDiffuse;
}

#define __FRAGMENT_MAIN__
#include "shMainRenderer.shader"
