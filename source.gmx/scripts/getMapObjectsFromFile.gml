/// loadMapFromStr(content)

var filename = argument0

var f = FS_file_text_open_read(filename)
var content = FS_file_text_read_string(f)
FS_file_text_close(f)

var result = array_create(0);
var resultIndex = 0;

var index = 1
var currentstring = ''
var section_number = 0
var delim = '|'
var versionstring = ''
var mapver_major = 0

while index <= string_length(content) {
    var nextchar = string_char_at(content,index);
    if nextchar != delim {
         currentstring += nextchar
    }
    if nextchar == delim or index == string_length(content) {
        // jtool
        if section_number == 0 and currentstring != 'jtool'{
            inputOverlay(input_info,false,'Not a valid jtool map.')
            exit
        }
        // version
        else if section_number == 1 {
            var mapver_major = real(splitDelimString(currentstring,'.',0))
            if mapver_major > global.version_major {
                inputOverlay(input_info,false,'Warning: may not be compatible with map;#it has a new major version.')
            }
        }
        // everything else
        else if section_number > 1 {
            var prefix = splitDelimString(currentstring,':',0)
            var suffix = splitDelimString(currentstring,':',1)
            if prefix == 'objects' {
                var objectstring = suffix
                var i = 1
                var yy = 0
                while i <= string_length(objectstring) {
                    if string_copy(objectstring,i,1) == '-' {
                        yy = base32StringToInt(string_copy(objectstring,i+1,2))
                        i += 3
                    }
                    else {
                        var objectid = saveIDToObject(base32StringToInt(string_copy(objectstring,i,1)))
                        if objectid != noone {
                            var xx = base32StringToInt(string_copy(objectstring,i+1,2));
                            result[resultIndex] = xx - 128;
                            ++resultIndex;
                            result[resultIndex] = yy - 128;
                            ++resultIndex;
                            result[resultIndex] = objectid;
                            ++resultIndex;
                        }
                        i += 3
                    }
                }
            }
        }
        section_number += 1
        currentstring = ''
    }
    index += 1
}

return result;
