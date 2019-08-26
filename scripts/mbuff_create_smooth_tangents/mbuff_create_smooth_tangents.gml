/// @description mbuff_create_smooth_tangents(modelBuffer, bytesPerVert)
/// @param modelBuffer
/// @param bytesPerVert
/*
	Generates smooth vertex tangents, encoded as colour.
	modelBuffer must be a regular buffer, not a vertex buffer.
	This script will simple update the given vertex buffer, and will as such not return anything.

	Assumes the vertex format contains 3D position, then normals, then texcoords, then colour (whereby the latter will be used as tangents)

	Script made by TheSnidr
	www.TheSnidr.com
*/
var mBuff, bytesPerVert, bufferSize, tangentMap, vertNum, bitangent, key, t, i, P0, P1, P2, P3, P4, P5, P6, P7, P8, N0, N1, N2, N3, N4, N5, N6, N7, N8, T0, T1, T2, T3, T4, T5, l, p1x, p1y, p1z, p2x, p2y, p2z, s1, s2, t1, t2, r, sdx, sdy, sdz, tdx, tdy, tdz, dp, Tx, Ty, Tz, Th, b;
mBuff = argument0;
bytesPerVert = argument1;
bufferSize = buffer_get_size(mBuff);
tangentMap = ds_map_create();
vertNum = bufferSize div bytesPerVert;
bitangent = array_create(vertNum);
for (i = 0; i < bufferSize; i += 3 * bytesPerVert)
{
	//Read triangle data from the vertex buffer
	buffer_seek(mBuff, buffer_seek_start, i)
	P0 = buffer_read(mBuff, buffer_f32);
	P1 = buffer_read(mBuff, buffer_f32);
	P2 = buffer_read(mBuff, buffer_f32);
	N0 = buffer_read(mBuff, buffer_f32);
	N1 = buffer_read(mBuff, buffer_f32);
	N2 = buffer_read(mBuff, buffer_f32);
	T0 = buffer_read(mBuff, buffer_f32);
	T1 = buffer_read(mBuff, buffer_f32);
	
	buffer_seek(mBuff, buffer_seek_start, i + bytesPerVert)
	P3 = buffer_read(mBuff, buffer_f32);
	P4 = buffer_read(mBuff, buffer_f32);
	P5 = buffer_read(mBuff, buffer_f32);
	N3 = buffer_read(mBuff, buffer_f32);
	N4 = buffer_read(mBuff, buffer_f32);
	N5 = buffer_read(mBuff, buffer_f32);
	T2 = buffer_read(mBuff, buffer_f32);
	T3 = buffer_read(mBuff, buffer_f32);
	
	buffer_seek(mBuff, buffer_seek_start, i + 2 * bytesPerVert)
	P6 = buffer_read(mBuff, buffer_f32);
	P7 = buffer_read(mBuff, buffer_f32);
	P8 = buffer_read(mBuff, buffer_f32);
	N6 = buffer_read(mBuff, buffer_f32);
	N7 = buffer_read(mBuff, buffer_f32);
	N8 = buffer_read(mBuff, buffer_f32);
	T4 = buffer_read(mBuff, buffer_f32);
	T5 = buffer_read(mBuff, buffer_f32);
	
	p1x = P3 - P0;
	p1y = P4 - P1;
	p1z = P5 - P2;
	p2x = P6 - P0;
	p2y = P7 - P1;
	p2z = P8 - P2;
		
	s1 = T2 - T0;
	s2 = T4 - T0;
	t1 = T3 - T1;
	t2 = T5 - T1;
		
	var r, sdx, sdy, sdz, tdx, tdy, tdz, dp, Tx, Ty, Tz, Th;
    r = 1.0 / (s1 * t2 - s2 * t1);
	sdx = (t2 * p1x - t1 * p2x) * r;
	sdy = (t2 * p1y - t1 * p2y) * r;
	sdz = (t2 * p1z - t1 * p2z) * r;
	tdx = (s1 * p2x - s2 * p1x) * r;
	tdy = (s1 * p2y - s2 * p1y) * r;
	tdz = (s1 * p2z - s2 * p1z) * r;
	
	//Add the tangent to the ds_map
	dp = N0 * sdx + N1 * sdy + N2 * sdz;
	Tx = sdx - N0 * dp;
	Ty = sdy - N1 * dp;
	Tz = sdz - N2 * dp;
	l = sqrt(sqr(Tx) + sqr(Ty) + sqr(Tz));
	if l != 0{
		Tx /= l;
		Ty /= l;
		Tz /= l;}
	key = string(P0) + "," + string(P1) + "," + string(P2);
	t = tangentMap[? key]
	if is_undefined(t)
	{
		tangentMap[? key] = [Tx, Ty, Tz];
	}
	else
	{
		t[@ 0] += Tx;
		t[@ 1] += Ty;
		t[@ 2] += Tz;
	}
	
	
	dp = N3 * sdx + N4 * sdy + N5 * sdz;
	Tx = sdx - N3 * dp;
	Ty = sdy - N4 * dp;
	Tz = sdz - N5 * dp;
	l = sqrt(sqr(Tx) + sqr(Ty) + sqr(Tz));
	if l != 0{
		Tx /= l;
		Ty /= l;
		Tz /= l;}
	key = string(P3) + "," + string(P4) + "," + string(P5);
	t = tangentMap[? key]
	if is_undefined(t)
	{
		tangentMap[? key] = [Tx, Ty, Tz];
	}
	else
	{
		t[@ 0] += Tx;
		t[@ 1] += Ty;
		t[@ 2] += Tz;
	}
	
	
	dp = N6 * sdx + N7 * sdy + N8 * sdz;
	Tx = sdx - N6 * dp;
	Ty = sdy - N7 * dp;
	Tz = sdz - N8 * dp;
	l = sqrt(sqr(Tx) + sqr(Ty) + sqr(Tz));
	if l != 0{
		Tx /= l;
		Ty /= l;
		Tz /= l;}
	key = string(P6) + "," + string(P7) + "," + string(P8);
	t = tangentMap[? key]
	if is_undefined(t)
	{
		tangentMap[? key] = [Tx, Ty, Tz];
	}
	else
	{
		t[@ 0] += Tx;
		t[@ 1] += Ty;
		t[@ 2] += Tz;
	}
}
//Write the tangent to the model
for (i = 0; i < vertNum; i ++)
{
	buffer_seek(mBuff, buffer_seek_start, i * bytesPerVert)
	P0 = buffer_read(mBuff, buffer_f32);
	P1 = buffer_read(mBuff, buffer_f32);
	P2 = buffer_read(mBuff, buffer_f32);
	N0 = buffer_read(mBuff, buffer_f32);
	N1 = buffer_read(mBuff, buffer_f32);
	N2 = buffer_read(mBuff, buffer_f32);
	key = string(P0) + "," + string(P1) + "," + string(P2);
	t = tangentMap[? key];
	dp = t[0] * N0 + t[1] * N1 + t[2] * N2;
	Tx = t[0] - N0 * dp;
	Ty = t[1] - N1 * dp;
	Tz = t[2] - N2 * dp;
	l = sqrt(sqr(Tx) + sqr(Ty) + sqr(Tz));
	Tx /= l;
	Ty /= l;
	Tz /= l;
	//Calculate handedness
	b = bitangent[i];
	Th = sign(b[0] * (Ty * N8 - Tz * N7) + b[1] * (Tz * N6 - Tx * N8) + b[2] * (Tx * N7 - Ty * N6));
	buffer_write(mBuff, buffer_u8, (Tx + 1) * 127);
	buffer_write(mBuff, buffer_u8, (Ty + 1) * 127);
	buffer_write(mBuff, buffer_u8, (Tz + 1) * 127);
	buffer_write(mBuff, buffer_u8, (Th + 1) * 127);
}
	
ds_map_destroy(tangentMap);