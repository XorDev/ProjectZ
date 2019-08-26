/// @desc Mathgik
// Projection matrix
/*mProj = matrix_build_identity();
mProj[_m(0, 0)] = +2 / (Max[0] - Min[0]);
mProj[_m(1, 1)] = +2 / (Max[1] - Min[1]);
mProj[_m(2, 2)] = -2 / (Max[2] - Min[2]);
mProj[_m(3, 3)] = 1;

// Update
// Camera rotation
var mRot = matrix_build_identity();
matrix_add_rotation_axis(0, 1, 0, fDir /* Yaw * /, mRot); // Try defaults: 0, 1, 0
matrix_add_rotation_axis(1, 0, 0, fPitch  , mRot); // Try defaults: 1, 0, 0

var vForward = matrix_transform_vertex(mRot, Forward[0], Forward[1], Forward[2]);
var toFar  = [vForward[0] * ShwDist, vForward[1] * ShwDist, vForward[2] * ShwDist];
var toNear = [vForward[0] * fNear  , vForward[1] * fNear  , vForward[2] * fNear  ];

var cNear = [x + toNear[0], y + toNear[1], z + toNear[2]];
var cFar  = [x + toFar [0], y + toFar [1], z + toFar [2]];

// Calculate frustrum verices
var vUp    = matrix_transform_vertex_4(mRot, Up);
var vRight = cross_product_normalised(vForward[0], vForward[1], vForward[2], vUp[0], vUp[1], vUp[2]);
var vDown  = [-vUp[0], -vUp[1], -vUp[2]];
var vLeft  = [-vRight[0], -vRight[1], -vRight[2]];

var FarTop     = [cFar [0] + vUp  [0] * FarH , cFar [1] + vUp  [1] * FarH , cFar [2] + vUp  [2] * FarH];
var FarBottom  = [cFar [0] + vDown[0] * FarH , cFar [1] + vDown[1] * FarH , cFar [2] + vDown[2] * FarH];
var NearTop    = [cNear[0] + vUp  [0] * NearH, cNear[1] + vUp  [1] * NearH, cNear[2] + vUp  [2] * NearH];
var NearBottom = [cNear[0] + vDown[0] * NearH, cNear[1] + vDown[1] * NearH, cNear[2] + vDown[2] * NearH];

var points;
points[0] = LightSpaceFrustumCorner(FarTop    , vRight, FarW );
points[1] = LightSpaceFrustumCorner(FarTop    , vLeft , FarW );
points[2] = LightSpaceFrustumCorner(FarBottom , vRight, FarW );
points[3] = LightSpaceFrustumCorner(FarBottom , vLeft , FarW );
points[4] = LightSpaceFrustumCorner(NearTop   , vRight, NearW);
points[5] = LightSpaceFrustumCorner(NearTop   , vLeft , NearW);
points[6] = LightSpaceFrustumCorner(NearBottom, vRight, NearW);
points[7] = LightSpaceFrustumCorner(NearBottom, vLeft , NearW);

var first = true;
for( var i = 0; i < 8; i++ ) {
    var point = points[i];
    if( first ) {
        for( var j = 0; j < 3; j++ ) {
            Min[j] = point[j];
            Max[j] = point[j];
        }
        
        first = false;
        continue;
    }
    
    for( var j = 0; j < 3; j++ ) {
        if( point[j] > Max[j] ) {
            Max[j] = point[j];
        } else {
            Min[j] = point[j];
        }
    }
}

Max[2] += Offset;

// View matrix
var lDir = [-x, -y, -z];
var len = point_distance_3d(0, 0, 0, lDir[0], lDir[1], lDir[2]);
lDir = [lDir[0] / len, lDir[1] / len, lDir[2] / len];

var center = matrix_transform_vertex_4(matrix_inverse(mView), 
    [(Min[0] + Max[0]) * .5, (Min[1] + Max[1]) * .5, (Min[2] + Max[2]) * .5, 1]);
center = [-center[0], -center[1], -center[2]];

mView = matrix_build_identity();

fPitch = arccos(point_distance(0, 0, lDir[0], lDir[1]));
mView = matrix_add_rotation_axis(1, 0, 0, -fPitch, mView);

fDir = darctan(lDir[0] / lDir[2]);
fDir = (lDir[2] > 0) ? (fDir - 180) : fDir;
mView = matrix_add_rotation_axis(0, 1, 0, degtorad(fDir), mView);

mView = matrix_add_translate(center[0], center[1], center[2], mView);

// 
var mOffset = matrix_build_identity();

// Translate
mOffset[_m(3, 0)] = .5;
mOffset[_m(3, 1)] = .5;
mOffset[_m(3, 2)] = .5;

// Scale
mOffset[_m(0, 0)] = .5;
mOffset[_m(1, 0)] =  0;
mOffset[_m(2, 0)] =  0;

mOffset[_m(1, 1)] = .5;
mOffset[_m(0, 1)] =  0;
mOffset[_m(2, 1)] =  0;

mOffset[_m(2, 2)] = .5;
mOffset[_m(1, 2)] =  0;
mOffset[_m(0, 2)] =  0;*/

//var _x = x + w * .5*0, _y = y + w * .5*0;
//mView = matrix_build_lookat(_x, _y, -16000, _x, _y, 0, dsin(0), dcos(0), 0);
mView = matrix_build_lookat(x, y, z, x + 32 * dcos(fDir), y - 32 * dsin(fDir), z - 32 * dtan(fPitch), 0, 0, 1);

mLightSpace = matrix_multiply(mView, mProj);
//mLightSpace = matrix_multiply(mOffset, mLightSpace);
