var questionFile = FS_file_text_open_read(prefix_project_path_if_needed("question.json"));
if (questionFile == -1) {
    show_error("Fail to open question.json.", true);
    exit;
}

var questionJson = "";
while (!FS_file_text_eof(questionFile)) {
    questionJson += FS_file_text_read_string(questionFile);
    FS_file_text_readln(questionFile);
}
FS_file_text_close(questionFile);
var questionMap = json_decode(questionJson);
if (questionMap == -1) {
    show_error("Invalid json in question.json.", true);
    exit;
}

global.avObjects = array_create(0);
global.avObjectMap = ds_map_create();

global.questionMaps = array_create(0);
global.skins = array_create(0);
global.timeLimits = array_create(0);
global.questionTips = array_create(0);
global.spikeLimits = array_create(0);
global.scores = array_create(0);
global.gameNames = array_create(0);

// 读取可用物体
if (ds_map_exists(questionMap, "avObject")) {
    var avObject = questionMap[? "avObject"];
    if (ds_exists(avObject, ds_type_list)) {
        for (var i = 0, size = ds_list_size(avObject); i != size; ++i) {
            var object = avObject[| i];
            if (is_string(object)) {
                if (asset_get_type(object) == asset_object) {
                    var objectIndex = asset_get_index(object);
                    global.avObjects[i] = objectIndex;
                    global.avObjectMap[? objectIndex] = 0;
                } else {
                    show_error("'avObject[" + string(i) + "] = " + object + "' is not an object asset.", true);
                    exit;
                }
            } else {
                show_error("'avObject[" + string(i) + "]' is not a string.", true);
                exit;
            }
        }
    
        ds_list_destroy(avObject);
    } else {
        show_error("'avObject' is not an array.", true);
        exit;
    }
} else {
    show_error("Key 'avObject' does not exist.", true);
    exit;
}

// 读取题目
if (ds_map_exists(questionMap, "question")) {
    var question = questionMap[? "question"];
    if (ds_exists(question, ds_type_list)) {
        for (var i = 0, size = ds_list_size(question); i != size; ++i) {
            var q = question[| i];
            if (ds_exists(q, ds_type_map)) {
                var map;
                var skin;
                var timeLimit;
                var questionTip;
                var spikeLimit;
                var _score;
                var gameName;
                
                if (ds_map_exists(q, "map")) {
                    map = q[? "map"];
                    if (is_string(map)) {
                        var fullPath = prefix_project_path_if_needed(map);
                        if (FS_file_exists(fullPath)) {
                            global.questionMaps[i] = fullPath;
                        } else {
                            show_error("Map '" + map + "' does not exist.", true);
                            exit;
                        }
                    } else {
                        show_error("'question[" + string(i) + "].map' is not a string.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].map' does not exist.", true);
                    exit;
                }
                
                if (ds_map_exists(q, "skin")) {
                    skin = q[? "skin"];
                    if (is_string(skin)) {
                        var skinFullPath = prefix_project_path_if_needed("skins\" + skin + "\");
                        if (FS_directory_exists(skinFullPath)) {
                            global.skins[i] = skin;
                        } else {
                            show_error("Skin '" + skin + "' does not exist.", true);
                            exit;
                        }
                    } else {
                        show_error("'question[" + string(i) + "].skin' is not a string.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].skin' does not exist.", true);
                    exit;
                }
                
                if (ds_map_exists(q, "timeLimit")) {
                    timeLimit = q[? "timeLimit"];
                    if (is_real(timeLimit)) {
                        if (timeLimit > 0) {
                            global.timeLimits[i] = timeLimit;
                        } else {
                            show_error("'question[" + string(i) + "].timeLimit = " + string(timeLimit) + "' is not positive.", true);
                            exit;
                        }
                    } else {
                        show_error("'question[" + string(i) + "].timeLimit' is not a number.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].timeLimit' does not exist.", true);
                    exit;
                }
                
                if (ds_map_exists(q, "questionTip")) {
                    questionTip = q[? "questionTip"];
                    if (is_string(questionTip)) {
                        global.questionTips[i] = questionTip;
                    } else {
                        show_error("'question[" + string(i) + "].questionTip' is not a string.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].questionTip' does not exist.", true);
                    exit;
                }
                
                if (ds_map_exists(q, "spikeLimit")) {
                    spikeLimit = q[? "spikeLimit"];
                    if (is_real(spikeLimit)) {
                        if (spikeLimit > 0) {
                            global.spikeLimits[i] = spikeLimit;
                        } else {
                            show_error("'question[" + string(i) + "].spikeLimit = " + string(spikeLimit) + "' is not positive.", true);
                            exit;
                        }
                    } else {
                        show_error("'question[" + string(i) + "].spikeLimit' is not a number.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].spikeLimit' does not exist.", true);
                    exit;
                }
                
                if (ds_map_exists(q, "score")) {
                    _score = q[? "score"];
                    if (ds_exists(_score, ds_type_map)) {
                        var scoreList = array_create(0);
                        for (var key = ds_map_find_first(_score); !is_undefined(key); key = ds_map_find_next(_score, key)) {
                            if (is_string(key)) {
                                var delimPos = string_pos("-", key);
                                if (delimPos == 0) {
                                    var index = real(key);
                                    scoreList[index] = _score[? key];
                                } else {
                                    var start = real(string_copy(key, 1, delimPos - 1));
                                    var theEnd = real(string_copy(key, delimPos + 1, string_length(key) - delimPos));
                                    for (var j = start; j <= theEnd; ++j) {
                                        scoreList[j] = _score[? key];
                                    }
                                }
                            } else {
                                show_error("Key " + string(key) + " of 'question[" + string(i) + "].score' is not a string.", true);
                                exit;
                            }
                        }
                        global.scores[i] = scoreList;
                        ds_map_destroy(_score);
                    } else {
                        show_error("'question[" + string(i) + "].score' is not an object.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].score' does not exist.", true);
                    exit;
                }
                
                if (ds_map_exists(q, "gameName")) {
                    gameName = q[? "gameName"];
                    if (is_string(gameName)) {
                        global.gameNames[i] = gameName;
                    } else {
                        show_error("'question[" + string(i) + "].gameName' is not a string.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].gameName' does not exist.", true);
                    exit;
                }
            } else {
                show_error("'question[" + string(i) + "]' is not an object.", true);
                exit;
            }
        }
        ds_list_destroy(question);
    } else {
        show_error("'question' is not an array.", true);
        exit;
    }
} else {
    show_error("Key 'question' does not exist.", true);
    exit;
}
ds_map_destroy(questionMap);

