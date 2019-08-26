/// @arg fname
var fname = argument0;

if( !file_exists(fname) ) {
    show_debug_message("[TGALoader]: " + fname + " doesn't exists!");
    return -1;
}

if( global.TGABuffer[? fname] != undefined ) {
    //show_debug_message("[TGALoader]: *" + fname + " -> " + string(array_get(global.TGABuffer[? fname], 0)));
    return array_get(global.TGABuffer[? fname], 0);
}

var buff = buffer_load(fname);

var offset = 4 * 1 + 4 * 2; // (Bytes)
var totalSize = 24; // (Bytes)

// Skip useless stuff
buffer_seek(buff, buffer_seek_start, offset);

// Load meta
var width   = buffer_read(buff, buffer_u16);
var height  = buffer_read(buff, buffer_u16);
var bitPP   = buffer_read(buff, buffer_u8);

// BPP & CHs
var ch = 0;
switch( bitPP ) {
         //       R   G   B   A
    case 32: ch = 1 | 2 | 4 | 8; break; // Full R G B A
    case 24: ch = 1 | 2 | 4    ; break; // Only R G B
    case 16: ch = 1 | 2        ; break; // Only R G
    case 8 : ch = 1            ; break; // Only R
    default:
        show_debug_message("[TGALoader]: Unsupported BPP (" + fname + ")");
        buffer_delete(buff);
        return -1;
}

if( file_exists("Cache\\TGA\\" + fname) ) {
    var ref = buffer_load("Cache\\TGA\\" + fname);
    buffer_seek(ref, buffer_seek_start, 0); // Seek from the beginning
} else {
#region Load TGA
var imgDesc = buffer_read(buff, buffer_u8);

// BPP & CHs
var ch = 0;
switch( bitPP ) {
         //       R   G   B   A
    case 32: ch = 1 | 2 | 4 | 8; break; // Full R G B A
    case 24: ch = 1 | 2 | 4    ; break; // Only R G B
    case 16: ch = 1 | 2        ; break; // Only R G
    case 8 : ch = 1            ; break; // Only R
    default:
        show_debug_message("[TGALoader]: Unsupported BPP (" + fname + ")");
        buffer_delete(buff);
        return -1;
}

// Load image data
var size = width * height * 4; // Total size of image
var ref = buffer_create(size, buffer_fast, 1);
buffer_seek(ref, buffer_seek_start, 0); // Seek from the beginning
for( var i = 0; i < size; i += 4 ) {
    // Read
    var r =                   buffer_read(buff, buffer_u8)    ; // R
    var g = ((ch & 2) == 2) ? buffer_read(buff, buffer_u8) : 0; // G
    var b = ((ch & 4) == 4) ? buffer_read(buff, buffer_u8) : 0; // B
    var a = ((ch & 8) == 8) ? buffer_read(buff, buffer_u8) : 0; // A
    
    if( (ch & 8) != 8 ) { // If less than 4 channels
        if( ch == 1 ) { b = r; g = r;} // If only 1 channel
        a = 255; // If less than 4 channels
    }
    
    // Write
    buffer_write(ref, buffer_u8, b); // B
    buffer_write(ref, buffer_u8, g); // G
    buffer_write(ref, buffer_u8, r); // R
    buffer_write(ref, buffer_u8, a); // A
}
#endregion
}

// Convert buffer -> surface
var s = surface_create(width, height);
buffer_set_surface(ref, s, 0, 0, 0);

// Cache
buffer_save(ref, "Cache\\TGA\\" + fname);

// Free memory
buffer_delete(ref);
buffer_delete(buff);

var b = ["R8", "R8G8", "R8G8B8", "A8R8G8B8"];
var _x_ = log2(ch);
show_debug_message("[TGALoader]: Loaded(fname=\"" + fname + "\", format=" + b[_x_] + ", sid=" + string(s) + ")");
global.TGABuffer[? fname] = [s, fname, ch, _x_, b[_x_]];
return s;
