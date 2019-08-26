/// @arg string
var o = argument0;

var s = "";
for( var i = 1; i <= string_length(o); i += 2 ) {
    var b = string_char_at(o, i);
    var c = string_char_at(o, i + 1);
    
    s += string_repeat(c, ord(b));
}

show_debug_message("[RLE]: " + s + " <- " + o);
return s;
