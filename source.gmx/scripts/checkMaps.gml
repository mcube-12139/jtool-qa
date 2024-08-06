/// checkMaps()
// 检查题目设定是否正确

for (var i = 0, count = array_length_1d(global.questionMaps); i != count; ++i) {
    var path = global.questionMaps[i];
    
    // 计算可摆实例数
    var objects = getMapObjectsFromFile(path);
    var avCount = 0;
    for (var j = 0, objectCount = array_length_1d(objects); j != objectCount; j += 3) {
        var objectIndex = objects[j + 2];
        if (isAVObject(objectIndex)) {
            ++avCount;
        }
    }
    
    // 检查限制摆刺数够不够
    if (avCount > global.spikeLimits[i]) {
        show_error("'question[" + string(i) + "].spikeLimit = " + string(global.spikeLimits[i]) + "' is too few." + chr(10) + "spike_count_in_map = " + string(avCount), false);
    }
    
    // 检查分数范围是否符合可摆实例数
    var scoreListLength = array_length_1d(global.scores[i]);
    if (scoreListLength != avCount + 1) {
        show_error("'question[" + string(i) + "].score.length = " + string(scoreListLength) + "' is not matched." + chr(10) + "spike_count_in_map = " + string(avCount), false);
        exit;
    }
}
