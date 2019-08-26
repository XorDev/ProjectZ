/// @description mbuff_create_flat_normals(modelBuffer, bytesPerVert)
/// @param modelBuffer
/// @param bytesPerVert
/*
	Generates flat normals
	modelBuffer must be a regular buffer, not a vertex buffer.
	This script will simple update the given vertex buffer, and will as such not return anything.

	Assumes that the vertex format contains a 3D position, and then normals

	Script made by TheSnidr
	www.TheSnidr.com
*/
var mBuff, bytesPerVert, bufferSize, i, P0, P1, P2, P3, P4, P5, P6, P7, P8, x1, y1, z1, x2, y2, z2, Nx, Ny, Nz, l, j;
mBuff = argument0;
bytesPerVert = argument1;
bufferSize = buffer_get_size(mBuff);
for (i = 0; i < bufferSize; i += 3 * bytesPerVert)
{
	//Read the three vertices of the triangle
	buffer_seek(mBuff, buffer_seek_start, i);
	P0 = buffer_read(mBuff, buffer_f32);
	P1 = buffer_read(mBuff, buffer_f32);
	P2 = buffer_read(mBuff, buffer_f32);
	buffer_seek(mBuff, buffer_seek_start, i + bytesPerVert);
	P3 = buffer_read(mBuff, buffer_f32);
	P4 = buffer_read(mBuff, buffer_f32);
	P5 = buffer_read(mBuff, buffer_f32);
	buffer_seek(mBuff, buffer_seek_start, i + 2 * bytesPerVert);
	P6 = buffer_read(mBuff, buffer_f32);
	P7 = buffer_read(mBuff, buffer_f32);
	P8 = buffer_read(mBuff, buffer_f32);

	//Generate flat normal
	x1 = P0 - P3;
	y1 = P1 - P4;
	z1 = P2 - P5;
	x2 = P0 - P6;
	y2 = P1 - P7;
	z2 = P2 - P8;
	Nx = y1 * z2 - z1 * y2;
	Ny = z1 * x2 - x1 * z2;
	Nz = x1 * y2 - y1 * z2;
	l = sqrt(sqr(Nx) + sqr(Ny) + sqr(Nz));
	if l > 0
	{
		Nx /= l;
		Ny /= l;
		Nz /= l;
	}
	
	j = i + 12;
	buffer_seek(mBuff, buffer_seek_start, j); //Assume that the vertex format stores positions first, and then normals
	buffer_write(mBuff, buffer_f32, Nx);
	buffer_write(mBuff, buffer_f32, Ny);
	buffer_write(mBuff, buffer_f32, Nz);
	buffer_seek(mBuff, buffer_seek_start, j + bytesPerVert);
	buffer_write(mBuff, buffer_f32, Nx);
	buffer_write(mBuff, buffer_f32, Ny);
	buffer_write(mBuff, buffer_f32, Nz);
	buffer_seek(mBuff, buffer_seek_start, j + 2 * bytesPerVert);
	buffer_write(mBuff, buffer_f32, Nx);
	buffer_write(mBuff, buffer_f32, Ny);
	buffer_write(mBuff, buffer_f32, Nz);
}