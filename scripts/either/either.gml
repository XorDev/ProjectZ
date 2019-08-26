/// @arg value
/// @arg v1
/// @arg ...
/// @arg vn
var v = argument[0];
for( var i = 1; i < argument_count; i++ ) if( v == argument[i] ) return true;
return false;
