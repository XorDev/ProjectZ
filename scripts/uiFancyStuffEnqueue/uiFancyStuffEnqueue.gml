/// @arg flags
/// @arg GIID
var flags = argument0;
var GIID = argument1;
var index = ds_list_find_index(__uiFancyQueue, GIID);

if( uiFlag(flags, uiFlags.Fancy) && index == -1 ) ds_list_add(__uiFancyQueue, GIID, 0);
