/// loadQuestionMap
// 载入地图，但只创建非答案实例

var filename = argument0

var f = FS_file_text_open_read(filename)
var content = FS_file_text_read_string(f)
FS_file_text_close(f)

loadQuestionMapFromStr(content);
