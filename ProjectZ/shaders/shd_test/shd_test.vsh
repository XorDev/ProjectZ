attribute vec4 in_Color;
attribute vec3 in_Position;
attribute vec3 in_Normal;

varying vec4 vColor;
varying vec3 vNormal;
varying vec3 vDepth;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position,1);
    
    vColor = in_Color;
	vNormal = (gm_Matrices[MATRIX_WORLD] * vec4(in_Normal,0)).xyz;
	vDepth = (gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Position,1)).xyz;
}