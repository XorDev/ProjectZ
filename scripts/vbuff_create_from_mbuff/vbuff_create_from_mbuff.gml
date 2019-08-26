/// @description vbuff_create_from_mbuff(mBuff)
/// @param mBuff
/*
	Creates a frozen vbuff from the given mbuff

	Script created by TheSnidr
	www.thesnidr.com
*/
var mBuff, vBuff, skinned, format, modelNum, i;
mBuff = argument0;
skinned = mbuff_get_skinned(mBuff);
format = skinned ? global.mBuffSkinnedFormat : global.mBuffStaticFormat;

modelNum = array_length_1d(mBuff);
if modelNum <= 1
{
	vBuff = vertex_create_buffer_from_buffer(mBuff[0], format);
	vertex_freeze(vBuff);
	return vBuff;
}

vBuff = array_create(modelNum);
for (i = 0; i < modelNum; i ++)
{
	vBuff[i] = vertex_create_buffer_from_buffer(mBuff[i], format);
	vertex_freeze(vBuff[i]);
}
return vBuff;