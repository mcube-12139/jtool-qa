/// nextMap()

++global.nowMapIndex;
if (global.nowMapIndex < array_length_1d(global.questionMaps)) {
    loadMap(global.questionMaps[global.nowMapIndex]);
    var backgroundCount = 0;
    with (all) {
        if (objectInPalette(object_index)) {
            background = true;
            ++backgroundCount;
        }
    }
    
    global.answerObjects = getMapObjectsFromFile(global.answerMaps[global.nowMapIndex]);
    global.answerCount = array_length_1d(global.answerObjects) / 3 - backgroundCount;
    
    ds_map_clear(global.answerObjectsPosMap);
    for (var i = 0, length = array_length_1d(global.answerObjects); i < length; i += 3) {
        var xx = global.answerObjects[i];
        var yy = global.answerObjects[i + 1];
        var objectID = global.answerObjects[i + 2];
        
        global.answerObjectsPosMap[? string(xx) + " " + string(yy)] = objectID;
    }
    
    global.timeLeft = room_speed * global.timeLimits[global.nowMapIndex];
    global.questionTip = global.questionTips[global.nowMapIndex];
    global.fuckGMScore = global.scores[global.nowMapIndex];
    global.spikeLimit = global.spikeLimits[global.nowMapIndex];
} else {
    room_goto(rEnd);
}
