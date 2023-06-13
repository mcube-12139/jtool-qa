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

global.questionMaps = array_create(0);
global.answerMaps = array_create(0);
global.timeLimits = array_create(0);
global.questionTips = array_create(0);
global.spikeLimits = array_create(0);
global.scores = array_create(0);
global.gameNames = array_create(0);

if (ds_map_exists(questionMap, "question")) {
    var question = questionMap[? "question"];
    if (ds_exists(question, ds_type_list)) {
        for (var i = 0, size = ds_list_size(question); i != size; ++i) {
            var q = question[| i];
            if (ds_exists(q, ds_type_map)) {
                var map;
                var answer;
                var timeLimit;
                var questionTip;
                var spikeLimit;
                var _score;
                var gameName;
                
                if (ds_map_exists(q, "map")) {
                    map = q[? "map"];
                    if (is_string(map)) {
                        global.questionMaps[i] = prefix_project_path_if_needed(map);
                    } else {
                        show_error("'question[" + string(i) + "].map' is not a string.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].map' does not exist.", true);
                    exit;
                }
                
                if (ds_map_exists(q, "answer")) {
                    answer = q[? "answer"];
                    if (is_string(answer)) {
                        global.answerMaps[i] = prefix_project_path_if_needed(answer);
                    } else {
                        show_error("'question[" + string(i) + "].answer' is not a string.", true);
                        exit;
                    }
                } else {
                    show_error("'question[" + string(i) + "].answer' does not exist.", true);
                    exit;
                }
                
                if (ds_map_exists(q, "timeLimit")) {
                    timeLimit = q[? "timeLimit"];
                    if (is_real(timeLimit)) {
                        global.timeLimits[i] = timeLimit;
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
                        global.spikeLimits[i] = spikeLimit;
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
    } else {
        show_error("'question' is not an array.", true);
        exit;
    }
} else {
    show_error("Key 'question' does not exist.", true);
    exit;
}

show_debug_message(global.answerMaps);

/*
global.questionMaps[0] = "jtool|1.3.5|inf:0|dot:0|sav:1|bor:0|px:40u8g00000000|py:40ubg00000000|ps:1|pg:1|objects:-70170160150-90150-80150-60150-50180170160150-h01f01g01h0-g0kg0";
global.answerMaps[0] = "jtool|1.3.5|inf:0|dot:0|sav:1|bor:0|px:40u8g00000000|py:40ubg00000000|ps:1|pg:1|objects:-70170160150-90150-80150-60150-50180170160150-h01f01g01h0-40570660350-g0kg0";
global.timeLimits[0] = 10;
global.questionTips[0] = "上下左";
global.spikeLimits[0] = 3;
var _score0 = array_create(0);
_score0[0] = 0;
_score0[1] = 25;
_score0[2] = 50;
_score0[3] = 100;
global.scores[0] = _score0;
global.gameNames[0] = "fuck";

global.questionMaps[1] = "jtool|1.3.5|inf:0|dot:0|sav:1|bor:0|px:40u8g00000000|py:40ubg00000000|ps:1|pg:1|objects:-70170160150-90150-80150-60150-50180170160150-h01f01g01h0-g0kg0";
global.answerMaps[1] = "jtool|1.3.5|inf:0|dot:0|sav:1|bor:0|px:40u8g00000000|py:40ubg00000000|ps:1|pg:1|objects:-h01h01g01f0-50150160170180540-60150-80150-90150-70150160170-g0kg0";
global.timeLimits[1] = 6;
global.questionTips[1] = "在左上角的砖左边放一个刺";
global.spikeLimits[1] = 2;
var _score1 = array_create(0);
_score1[0] = 0;
_score1[1] = 100;
global.scores[1] = _score1;
global.gameNames[1] = "bar";
*/
