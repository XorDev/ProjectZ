/// @description mbuff_get_boundingbox(mBuff)
/// @param mBuff
/*
	Returns the bounding box of the model as an array of the following format:
		[minX, minY, minZ, maxX, maxY, maxZ]
		
	The first time you try to get the bounding box on a new or edited model may take a bit of time.
*/
var mBuff = argument0;
if !is_array(mBuff){mBuff = [mBuff];}

if (!mbuff_get_metadata(mBuff))
{
	show_debug_message("ERROR in script mbuff_get_boundingbox: Model buffer does not contain metadata");
	return -1;
}
var bytesPerVert = mbuff_get_bytespervert(mBuff);

var minX = 999999;
var minY = 999999;
var minZ = 999999;
var maxX = -999999;
var maxY = -999999;
var maxZ = -999999;
var modelNum = array_length_1d(mBuff)
for (var m = 0; m < modelNum; m ++)
{
	var buff = mBuff[m];
	var write_size = buffer_peek(buff, 4 * 4 + 3, buffer_u8);
	if !write_size
	{
		mbuff_update_metadata(buff, mbuff_get_skinned(buff), true);
	}
	minX = min(minX, buffer_peek(buff, bytesPerVert + 3 * 4, buffer_f32));
	minY = min(minY, buffer_peek(buff, bytesPerVert + 4 * 4, buffer_f32));
	minZ = min(minZ, buffer_peek(buff, bytesPerVert + 5 * 4, buffer_f32));
	maxX = max(maxX, buffer_peek(buff, bytesPerVert + 6 * 4, buffer_f32));
	maxY = max(maxY, buffer_peek(buff, bytesPerVert + 7 * 4, buffer_f32));
	maxZ = max(maxZ, buffer_peek(buff, bytesPerVert + 8 * 4, buffer_f32));
}

return [minX, minY, minZ, maxX, maxY, maxZ];