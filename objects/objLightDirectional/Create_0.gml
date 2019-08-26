w = 4096; //WIDTH * 1;
h = 2048;

fFov = 120; //90;

fNear = 12;
fFar = 64000;
fAspect = w / h;
mProj = matrix_build_projection_perspective_fov(fFov, fAspect, fNear, fFar);

/*var finalMatrix = matrix_build_projection_ortho(WIDTH, WIDTH, 1.5, 16000);
finalMatrix[10] = -2/(argument5-argument4);
finalMatrix[14] = -((argument5+argument4)/(argument5-argument4));

return finalMatrix;*/


z = 0;
fDir = 0;
fPitch = 0;

// 
x = 845.53;
y = -608.91;
z = 971.4;
fDir = -126.4;
fPitch = 54;



// Ortho
//Up      = [ 0, 0, 1, 0];
//Forward = [ 1, 0, 0, 0];
//ShwDist = 100;
//Offset  = 10;
//
//Min = [+99999, +99999, +99999];
//Max = [-99999, -99999, -99999];
//
//FarW = ShwDist * dtan(fFov);
//FarH = FarW / fAspect;
//NearW = fNear * dtan(fFov);
//NearH = NearW / fAspect;
//
//// Projection
//mProj = matrix_build_identity();
//var ys = 1. / dtan(fFov * .5);
//var xs = ys / fAspect;
//var fLen = ShwDist - fNear;
//
//mProj[_m(0, 0)] = xs;
//mProj[_m(1, 1)] = ys;
//mProj[_m(2, 2)] = -((ShwDist + fNear) / fLen);
//mProj[_m(2, 3)] = -1;
//mProj[_m(3, 2)] = -2 * fNear * ShwDist / fLen;
//mProj[_m(3, 3)] = 0;
//
//
//mView = matrix_build_identity();
