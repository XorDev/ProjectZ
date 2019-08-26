/// @description dq_normalize(Q)
/// @param Q[8]
gml_pragma("forceinline");
var Q, l, d;
Q = argument0;
l = 1 / sqrt(sqr(Q[0]) + sqr(Q[1]) + sqr(Q[2]) + sqr(Q[3]));

Q[@ 0] *= l
Q[@ 1] *= l
Q[@ 2] *= l
Q[@ 3] *= l

d = Q[0] * Q[4] + Q[1] * Q[5] + Q[2] * Q[6] + Q[3] * Q[7];
Q[@ 4] = (Q[4] - Q[0] * d) * l;
Q[@ 5] = (Q[5] - Q[1] * d) * l;
Q[@ 6] = (Q[6] - Q[2] * d) * l;
Q[@ 7] = (Q[7] - Q[3] * d) * l;

return Q;