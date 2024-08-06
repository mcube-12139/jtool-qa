/// destroyAnswerInstances()
// 摧毁显示答案的实例
for (var i = 0, count = array_length_1d(global.answerInstances); i != count; ++i) {
    var instance = global.answerInstances[i];
    instance_destroy(instance);
}
