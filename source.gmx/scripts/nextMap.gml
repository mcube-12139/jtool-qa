/// nextMap()

++global.nowMapIndex;
if (global.nowMapIndex < array_length_1d(global.questionMaps)) {
    loadQuestionMap(global.questionMaps[global.nowMapIndex]);
    
    // 切换皮肤
    var skin = global.skins[global.nowMapIndex];
    loadSkin(skin);
    
    // 获取答案实例
    var objects = getMapObjectsFromFile(global.questionMaps[global.nowMapIndex]);
    
    global.answerObjects = array_create(0);
    ds_map_clear(global.answerObjectsPosMap);
    var index = 0;
    for (var i = 0, count = array_length_1d(objects); i != count; i += 3) {
        var objectIndex = objects[i + 2];
        if (isAVObject(objectIndex)) {
            var xx = objects[i];
            var yy = objects[i + 1];
            
            global.answerObjects[index] = xx;
            ++index;
            global.answerObjects[index] = yy;
            ++index;
            global.answerObjects[index] = objectIndex;
            ++index;
        
            global.answerObjectsPosMap[? string(xx) + " " + string(yy)] = objectIndex;
        }
    }
    global.answerCount = array_length_1d(global.answerObjects) / 3;
    
    global.timeLeft = room_speed * global.timeLimits[global.nowMapIndex];
    global.questionTip = global.questionTips[global.nowMapIndex];
    global.fuckGMScore = global.scores[global.nowMapIndex];
    global.spikeLimit = global.spikeLimits[global.nowMapIndex];
} else {
    room_goto(rEnd);
}
