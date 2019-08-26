// 
fFOV    = 70;
fNear   = 1.5;
fFar    = 64000;
fAspect = WIDTH / HEIGHT;

// 
z = 0;

// 
mView = matrix_build_identity();
mProj = matrix_build_projection_perspective_fov(fFOV, fAspect, fNear, fFar);
mInvProj = matrix_inverse(mProj);

// 
fSpd = 0;
max_fSpd = 12;

// 
fDir = 0;
fPitch = 0;

fx = 0;
fy = 0;
fz = 0;

