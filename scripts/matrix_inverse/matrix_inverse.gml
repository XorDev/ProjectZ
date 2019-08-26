/// @arg matrix
//
//  Returns the mathematical inverse of a matrix.
//  If the matrix is non-invertible, this script returns undefined.
//
//      matrix    4x4 matrix, 16-element array
//
//  Made by @jujuadams. With thanks to Russell Kay.
//
/// GMLscripts.com/license

var _mtx = argument0;
var _inv;                

_inv[ 0] = _mtx[ 5] * _mtx[10] * _mtx[15] - 
           _mtx[ 5] * _mtx[11] * _mtx[14] - 
           _mtx[ 9] * _mtx[ 6] * _mtx[15] + 
           _mtx[ 9] * _mtx[ 7] * _mtx[14] +
           _mtx[13] * _mtx[ 6] * _mtx[11] - 
           _mtx[13] * _mtx[ 7] * _mtx[10];

_inv[ 4] = -_mtx[ 4] * _mtx[10] * _mtx[15] + 
            _mtx[ 4] * _mtx[11] * _mtx[14] + 
            _mtx[ 8] * _mtx[ 6] * _mtx[15] - 
            _mtx[ 8] * _mtx[ 7] * _mtx[14] - 
            _mtx[12] * _mtx[ 6] * _mtx[11] + 
            _mtx[12] * _mtx[ 7] * _mtx[10];

_inv[ 8] = _mtx[ 4] * _mtx[ 9] * _mtx[15] - 
           _mtx[ 4] * _mtx[11] * _mtx[13] - 
           _mtx[ 8] * _mtx[ 5] * _mtx[15] + 
           _mtx[ 8] * _mtx[ 7] * _mtx[13] + 
           _mtx[12] * _mtx[ 5] * _mtx[11] - 
           _mtx[12] * _mtx[ 7] * _mtx[ 9];

_inv[12] = -_mtx[ 4] * _mtx[ 9] * _mtx[14] + 
            _mtx[ 4] * _mtx[10] * _mtx[13] +
            _mtx[ 8] * _mtx[ 5] * _mtx[14] - 
            _mtx[ 8] * _mtx[ 6] * _mtx[13] - 
            _mtx[12] * _mtx[ 5] * _mtx[10] + 
            _mtx[12] * _mtx[ 6] * _mtx[ 9];

var _det = _mtx[0] * _inv[0] + _mtx[1] * _inv[4]
         + _mtx[2] * _inv[8] + _mtx[3] * _inv[12];
if ( _det == 0 ) return undefined;

_inv[ 1] = -_mtx[ 1] * _mtx[10] * _mtx[15] + 
            _mtx[ 1] * _mtx[11] * _mtx[14] + 
            _mtx[ 9] * _mtx[ 2] * _mtx[15] - 
            _mtx[ 9] * _mtx[ 3] * _mtx[14] - 
            _mtx[13] * _mtx[ 2] * _mtx[11] + 
            _mtx[13] * _mtx[ 3] * _mtx[10];

_inv[ 5] = _mtx[ 0] * _mtx[10] * _mtx[15] - 
           _mtx[ 0] * _mtx[11] * _mtx[14] - 
           _mtx[ 8] * _mtx[ 2] * _mtx[15] + 
           _mtx[ 8] * _mtx[ 3] * _mtx[14] + 
           _mtx[12] * _mtx[ 2] * _mtx[11] - 
           _mtx[12] * _mtx[ 3] * _mtx[10];

_inv[ 9] = -_mtx[ 0] * _mtx[ 9] * _mtx[15] + 
            _mtx[ 0] * _mtx[11] * _mtx[13] + 
            _mtx[ 8] * _mtx[ 1] * _mtx[15] - 
            _mtx[ 8] * _mtx[ 3] * _mtx[13] - 
            _mtx[12] * _mtx[ 1] * _mtx[11] + 
            _mtx[12] * _mtx[ 3] * _mtx[ 9];

_inv[13] = _mtx[ 0]  * _mtx[ 9] * _mtx[14] - 
           _mtx[ 0]  * _mtx[10] * _mtx[13] - 
           _mtx[ 8]  * _mtx[ 1] * _mtx[14] + 
           _mtx[ 8]  * _mtx[ 2] * _mtx[13] + 
           _mtx[12] * _mtx[ 1] * _mtx[10] - 
           _mtx[12] * _mtx[ 2] * _mtx[ 9];

_inv[ 2] = _mtx[ 1] * _mtx[ 6] * _mtx[15] - 
           _mtx[ 1] * _mtx[ 7] * _mtx[14] - 
           _mtx[ 5] * _mtx[ 2] * _mtx[15] + 
           _mtx[ 5] * _mtx[ 3] * _mtx[14] + 
           _mtx[13] * _mtx[ 2] * _mtx[ 7] - 
           _mtx[13] * _mtx[ 3] * _mtx[ 6];

_inv[ 6] = -_mtx[ 0] * _mtx[ 6] * _mtx[15] + 
            _mtx[ 0] * _mtx[ 7] * _mtx[14] + 
            _mtx[ 4] * _mtx[ 2] * _mtx[15] - 
            _mtx[ 4] * _mtx[ 3] * _mtx[14] - 
            _mtx[12] * _mtx[ 2] * _mtx[ 7] + 
            _mtx[12] * _mtx[ 3] * _mtx[ 6];

_inv[10] = _mtx[ 0] * _mtx[ 5] * _mtx[15] - 
           _mtx[ 0] * _mtx[ 7] * _mtx[13] - 
           _mtx[ 4] * _mtx[ 1] * _mtx[15] + 
           _mtx[ 4] * _mtx[ 3] * _mtx[13] + 
           _mtx[12] * _mtx[ 1] * _mtx[ 7] - 
           _mtx[12] * _mtx[ 3] * _mtx[ 5];

_inv[14] = -_mtx[ 0] * _mtx[ 5] * _mtx[14] + 
            _mtx[ 0] * _mtx[ 6] * _mtx[13] + 
            _mtx[ 4] * _mtx[ 1] * _mtx[14] - 
            _mtx[ 4] * _mtx[ 2] * _mtx[13] - 
            _mtx[12] * _mtx[ 1] * _mtx[ 6] + 
            _mtx[12] * _mtx[ 2] * _mtx[ 5];

_inv[ 3] = -_mtx[ 1] * _mtx[ 6] * _mtx[11] + 
            _mtx[ 1] * _mtx[ 7] * _mtx[10] + 
            _mtx[ 5] * _mtx[ 2] * _mtx[11] - 
            _mtx[ 5] * _mtx[ 3] * _mtx[10] - 
            _mtx[ 9] * _mtx[ 2] * _mtx[ 7] + 
            _mtx[ 9] * _mtx[ 3] * _mtx[ 6];

_inv[ 7] = _mtx[ 0] * _mtx[ 6] * _mtx[11] - 
           _mtx[ 0] * _mtx[ 7] * _mtx[10] - 
           _mtx[ 4] * _mtx[ 2] * _mtx[11] + 
           _mtx[ 4] * _mtx[ 3] * _mtx[10] + 
           _mtx[ 8] * _mtx[ 2] * _mtx[ 7] - 
           _mtx[ 8] * _mtx[ 3] * _mtx[ 6];

_inv[11] = -_mtx[ 0] * _mtx[ 5] * _mtx[11] + 
            _mtx[ 0] * _mtx[ 7] * _mtx[ 9] + 
            _mtx[ 4] * _mtx[ 1] * _mtx[11] - 
            _mtx[ 4] * _mtx[ 3] * _mtx[ 9] - 
            _mtx[ 8] * _mtx[ 1] * _mtx[ 7] + 
            _mtx[ 8] * _mtx[ 3] * _mtx[ 5];

_inv[15] = _mtx[ 0] * _mtx[ 5] * _mtx[10] - 
           _mtx[ 0] * _mtx[ 6] * _mtx[ 9] - 
           _mtx[ 4] * _mtx[ 1] * _mtx[10] + 
           _mtx[ 4] * _mtx[ 2] * _mtx[ 9] + 
           _mtx[ 8] * _mtx[ 1] * _mtx[ 6] - 
           _mtx[ 8] * _mtx[ 2] * _mtx[ 5];

for( var _i = 0; _i < 16; _i++ ) _inv[_i] /= _det;
return _inv;
