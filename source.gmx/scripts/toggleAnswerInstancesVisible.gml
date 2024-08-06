/// toggleAnswerInstancesVisible()
// 切换显示答案的实例的显隐

for (var i = 0, count = array_length_1d(global.answerInstances); i != count; ++i) {
    var instance = global.answerInstances[i];
    with (instance) {
        visible = !visible;
    }
}
