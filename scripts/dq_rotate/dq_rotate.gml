/// @description dq_rotate(R, Q)
/// @param R[8]
/// @param Q[4]
//Rotates a dual quaternion around a quaternion
gml_pragma("forceinline");

var R, S;
R = argument0;
S = argument1;
return [R[3] * S[0] + R[0] * S[3] + R[1] * S[2] - R[2] * S[1],
		R[3] * S[1] + R[1] * S[3] + R[2] * S[0] - R[0] * S[2],
		R[3] * S[2] + R[2] * S[3] + R[0] * S[1] - R[1] * S[0],
		R[3] * S[3] - R[0] * S[0] - R[1] * S[1] - R[2] * S[2],
		R[7] * S[0] + R[4] * S[3] + R[5] * S[2] - R[6] * S[1],
		R[7] * S[1] + R[5] * S[3] + R[6] * S[0] - R[4] * S[2],
		R[7] * S[2] + R[6] * S[3] + R[4] * S[1] - R[5] * S[0],
		R[7] * S[3] - R[4] * S[0] - R[5] * S[1] - R[6] * S[2]];