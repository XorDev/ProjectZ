/// string_split(string, sep, real);
var s = argument0;
var sep = argument1;
var r = argument2;

var a, l = string_length(sep), _id_ = 0;
a[0] = "";

for( var i = 1; i <= string_length(s); i++ ) {
    var sp = string_copy(s, i, l);
    var char = string_char_at(s, i);
    
    if( sp != sep ) {
        // Isn't separator
        a[_id_] += char;
    } else {
        if( r ) a[_id_] = Real(a[_id_]);
        _id_++;
        a[_id_] = "";
    }
}

if( r ) a[array_length_1d(a) - 1] = real(a[array_length_1d(a) - 1]);

return a;
