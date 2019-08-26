/// @arg bitfield
var bitfield = argument0;

var a = [-1];
var size = 0;

for( var i = 1; i <= bfSize( bitfield ); i++ ) {
    if( uiFlag(bitfield, 1 << i) ) {
        a[size] = i - 1;
        size++;
    }
}

a = (bitfield);

//show_debug_message(bitfield);
//show_debug_message(a);//*/
return a;
