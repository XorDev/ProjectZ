/// @arg string
var s = argument0;

var o = "";
var count = 0, lc = "";
for( var i = 1; i <= string_length(s); i++ ) {
    var c = string_char_at(s, i);
    
    if( c == lc ) {
        count++;
    } else {
        if( count > 0 ) {
            o += chr(count) + lc;
        }
        
        lc = c;
        count = 1;
    }
}

if( count > 0 ) {
    o += chr(count) + lc;
}

show_debug_message("[RLE]: " + s + " -> " + o);
return o;
