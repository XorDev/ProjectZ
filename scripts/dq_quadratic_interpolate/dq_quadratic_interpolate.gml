/// @description dq_quadratic_interpolate(a, b, c, amount)
/// @param a
/// @param b
/// @param c
/// @param amount
var A, B, C, t0, t1, t2, R, i;
A = argument0;
B = argument1;
C = argument2;
t0 = sqr(1 - argument3);
t1 = sqr(argument3) * .5;
t2 = 2 * argument3 * (1 - argument3);

i = 8;
R = array_create(8);
while i--
{
	R[i] = (t0 * (A[i] + B[i]) + t1 * (B[i] + C[i])) + t2 * B[i]
}
return R;