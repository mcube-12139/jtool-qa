/// getPlayerAnswerCount()
var result = 0;

with (all) {
    if (objectInPalette(object_index) && !variable_instance_exists(id, "background") && !variable_instance_exists(id, "answer")) {
        ++result;
    }
}

return result;
