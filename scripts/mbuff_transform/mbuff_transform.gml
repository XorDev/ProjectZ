/// @description mbuff_transform(mbuff, matrix)
/// @param mbuff
/// @param matrix
/*
	Transforms a given model buffer by the given matrix.
	mbuff can also be an array of buffers, whereby each entry in the array will be transformed.
	
	Script created by TheSnidr, 2019
	www.TheSnidr.com
*/
var vx, vy, vz, nx, ny, nz, v, n;
var mBuff = argument0;
var M = argument1;

//Create normal matrix from world matrix
var N = array_create(16, 0);
array_copy(N, 0, M, 0, 16);
N[12] = 0;
N[13] = 0;
N[14] = 0;

if !is_array(mBuff){mBuff = [mBuff];}
var modelNum = array_length_1d(mBuff);
var bytesPerVert = mbuff_get_bytespervert(mBuff);

//Loop through the model buffers
for (var m = 0; m < modelNum; m ++)
{
	var buff = mBuff[m];
	var buffSize = buffer_get_size(buff);

	//Loop through the vertices of the buffer
	for (var i = 0; i < buffSize; i += bytesPerVert)
	{
		//Read vertex position and normal from buffer
		buffer_seek(buff, buffer_seek_start, i);
		vx = buffer_read(buff, buffer_f32);
		vy = buffer_read(buff, buffer_f32);
		vz = buffer_read(buff, buffer_f32);
		nx = buffer_read(buff, buffer_f32);
		ny = buffer_read(buff, buffer_f32);
		nz = buffer_read(buff, buffer_f32);
	
		//Transform vertex position and normal
		v = matrix_transform_vertex(M, vx, vy, vz);
		n = matrix_transform_vertex(N, nx, ny, nz);
	
		//Overwrite position and normal in the buffer
		buffer_seek(buff, buffer_seek_start, i);
		buffer_write(mBuff, buffer_f32, v[0]);
		buffer_write(mBuff, buffer_f32, v[1]);
		buffer_write(mBuff, buffer_f32, v[2]);
		buffer_write(mBuff, buffer_f32, n[0]);
		buffer_write(mBuff, buffer_f32, n[1]);
		buffer_write(mBuff, buffer_f32, n[2]);
	}
}