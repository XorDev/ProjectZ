#region Just delete it
#ifndef MATRIX_VIEW
#define	MATRIX_VIEW                  0
#define	MATRIX_PROJECTION            1
#define	MATRIX_WORLD                 2
#define	MATRIX_WORLD_VIEW            3
#define	MATRIX_WORLD_VIEW_PROJECTION 4
#define	MATRICES_MAX                 5 
#define	MAX_VS_LIGHTS                8

cbuffer gm_VSTransformBuffer
{
	float4x4 gm_Matrices[MATRICES_MAX];
};
#endif
#endregion

struct VS {
    float4 Position : POSITION0;
    float2 Texcoord : TEXCOORD0;
};

struct PS {
    float4 Position : SV_Position0;
    float2 Texcoord : TEXCOORD0;
    float3 CamVec   : TEXCOORD1;
};

float4x4 _mViewProjInv;

PS main(VS In) {
    float3 vFrustumCornersWS[8] = {
    	float3(-1.0,  1.0, 0.0),	// near top left
    	float3( 1.0,  1.0, 0.0),	// near top right
    	float3(-1.0, -1.0, 0.0),	// near bottom left
    	float3( 1.0, -1.0, 0.0),	// near bottom right
    	float3(-1.0,  1.0, 1.0),	// far top left
    	float3( 1.0,  1.0, 1.0),	// far top right
    	float3(-1.0, -1.0, 1.0),	// far bottom left
    	float3( 1.0, -1.0, 1.0)		// far bottom right
    };
    
    [unroll] for( int i = 0; i < 8; ++i ) {
    	float4 vCornerWS = mul(_mViewProjInv, float4(vFrustumCornersWS[i], 1.));
    	vFrustumCornersWS[i] = vCornerWS.xyz / vCornerWS.w;
    }
    
    [unroll] for( int i = 0; i < 4; ++i ) {
    	vFrustumCornersWS[i + 4] -= vFrustumCornersWS[i];
    }
    PS Out;
        Out.Position = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], In.Position);
        Out.Texcoord = In.Texcoord;
        
        
        float3 vCamVecLerpT = (Out.Position.x > 0) ? vFrustumCornersWS[5] : vFrustumCornersWS[4];
        float3 vCamVecLerpB = (Out.Position.x > 0) ? vFrustumCornersWS[7] : vFrustumCornersWS[6];	
        Out.CamVec = (Out.Position.y < 0) ? vCamVecLerpB : vCamVecLerpT;
    return Out;
}
