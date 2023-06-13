// Deletes all palette objects and loads a map from file.

var filename = argument0

var f = FS_file_text_open_read(filename)
var content = FS_file_text_read_string(f)
FS_file_text_close(f)

loadMapFromStr(content);
