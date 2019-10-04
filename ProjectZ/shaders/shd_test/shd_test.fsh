varying vec4 vColor;
varying vec3 vNormal;
varying vec3 vDepth;

void main()
{
	float Lambert = .6+.4*dot(normalize(vNormal),vec3(.6,.3,-.7));
	float Fog = 1.-exp(-length(vDepth)/1e3);
	const vec3 FogColor = vec3(32,32,48)/255.;
    gl_FragColor = vec4(mix(vColor.rgb*Lambert,FogColor,Fog),vColor.a);
}