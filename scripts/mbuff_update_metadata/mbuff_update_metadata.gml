/// @description mbuff_update_metadata(mBuff, skinned, write_size)
/// @param mBuff
/// @param skinned
/// @param write_size
/*
	Writes info about the vertex buffer's format to the vertex buffer itself.
	
	write_size must be true or false, indicating whether or not the size of the model should be updated
*/
var mBuff = argument0;
if !is_array(mBuff){mBuff = [mBuff];}

var skinned = argument1;
var write_size = argument2;
var bytesPerVert = skinned ? mBuffSkinnedBytesPerVert : mBuffStaticBytesPerVert;
var modelNum = array_length_1d(mBuff);

for (var m = 0; m < modelNum; m ++)
{
	var buff = mBuff[m];
	var buffSize = buffer_get_size(buff);

	////////////
	//If the buffer does not already contain metadata, move the contents of the buffer so that the first triangle can be used for metadata
	if (!mbuff_get_metadata(buff)) && 0
	{
		var tempBuff = buffer_create(buffSize, buffer_fixed, 1);
		buffer_copy(buff, 0, buffSize, tempBuff, 0);
	
		buffer_resize(buff, buffSize + bytesPerVert * 3);
		buffer_copy(tempBuff, 0, buffSize, buff, bytesPerVert * 3);
		buffSize += bytesPerVert * 3;
	}
	buffer_seek(buff, buffer_seek_start, 0);

	////////////
	//First vert
	buffer_write(buff, buffer_f32, 0); //x, must be 0
	buffer_write(buff, buffer_f32, 0); //y, must be 0
	buffer_write(buff, buffer_f32, 0); //z, must be 0

	//The rest of these can store metadata
	buffer_write(buff, buffer_u32, mBuffMetaDataID);

	buffer_write(buff, buffer_u8, skinned);
	buffer_write(buff, buffer_u8, bytesPerVert);
	buffer_write(buff, buffer_u8, write_size);
	buffer_write(buff, buffer_u8, 0);

	buffer_write(buff, buffer_f32, 0);
	buffer_write(buff, buffer_f32, 0);
	buffer_write(buff, buffer_f32, 0);
	buffer_write(buff, buffer_u32, 0);

	if skinned
	{
		buffer_write(buff, buffer_u32, 0);
		buffer_write(buff, buffer_u32, 0);
	}

	/////////////
	//Second vert

	//Find the size of the model
	if write_size
	{
		var v, i;
		var h = 9999999;
		var Min = [h, h, h];
		var Max = [-h, -h, -h];
		for (i = 3 * bytesPerVert; i < buffSize; i += bytesPerVert)
		{
			buffer_seek(buff, buffer_seek_start, i);
			v = buffer_read(buff, buffer_f32);
			Min[0] = min(Min[0], v);
			Max[0] = max(Max[0], v);
			v = buffer_read(buff, buffer_f32);
			Min[1] = min(Min[1], v);
			Max[1] = max(Max[1], v);
			v = buffer_read(buff, buffer_f32);
			Min[2] = min(Min[2], v);
			Max[2] = max(Max[2], v);
		}
	
		buffer_seek(buff, buffer_seek_start, bytesPerVert);
		buffer_write(buff, buffer_f32, 0); //x, must be 0
		buffer_write(buff, buffer_f32, 0); //y, must be 0
		buffer_write(buff, buffer_f32, 0); //z, must be 0

		//The rest of these can store metadata
		buffer_write(buff, buffer_f32, Min[0]);
		buffer_write(buff, buffer_f32, Min[1]);
		buffer_write(buff, buffer_f32, Min[2]);

		buffer_write(buff, buffer_f32, Max[0]);
		buffer_write(buff, buffer_f32, Max[1]);
		buffer_write(buff, buffer_f32, Max[2]);

		if skinned
		{
			buffer_write(buff, buffer_u32, 0);
			buffer_write(buff, buffer_u32, 0);
		}
	}
	else
	{
		buffer_write(buff, buffer_f32, 0); //x, must be 0
		buffer_write(buff, buffer_f32, 0); //y, must be 0
		buffer_write(buff, buffer_f32, 0); //z, must be 0

		//The rest of these can store metadata
		buffer_write(buff, buffer_f32, 0);
		buffer_write(buff, buffer_f32, 0);
		buffer_write(buff, buffer_f32, 0);

		buffer_write(buff, buffer_f32, 0);
		buffer_write(buff, buffer_f32, 0);
		buffer_write(buff, buffer_u32, 0);

		if skinned
		{
			buffer_write(buff, buffer_u32, 0);
			buffer_write(buff, buffer_u32, 0);
		}
	} 

	////////////
	//Third vert
	buffer_write(buff, buffer_f32, 0); //x, must be 0
	buffer_write(buff, buffer_f32, 0); //y, must be 0
	buffer_write(buff, buffer_f32, 0); //z, must be 0

	//The rest of these can store metadata
	buffer_write(buff, buffer_f32, 0);
	buffer_write(buff, buffer_f32, 0);
	buffer_write(buff, buffer_f32, 0);

	buffer_write(buff, buffer_f32, 0);
	buffer_write(buff, buffer_f32, 0);
	buffer_write(buff, buffer_u32, 0);

	if skinned
	{
		buffer_write(buff, buffer_u32, 0);
		buffer_write(buff, buffer_u32, 0);
	}
}