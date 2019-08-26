/// @description mbuff_add(target, source)
/// @param target
/// @param source
/*
	Adds the source mbuff array to the target's array.
	The target MUST be an array!
	
	Script created by TheSnidr, 2019
	www.TheSnidr.com
*/
var trg = argument0;
var src = argument1;
if !is_array(src){src = [src];}

var trgNum = array_length_1d(trg);
var srcNum = array_length_1d(src);
for (var i = 0; i < srcNum; i ++)
{
	trg[@ trgNum + i] = src[i];
}

return trg;