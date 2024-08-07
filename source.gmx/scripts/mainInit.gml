// Main init script that should be called once upon game start.

/* tell if we're running from the editor or from the compiled game,
   since that function isn't built into gm.
   the editor directory is similar to this:
   C:\Users\User\AppData\Local\Temp\gm_ttt_881\gm_ttt_30167\
   this assumes the user doesn't have their own folder containing "gm_ttt",
   but I think that's a safe assumption.
*/
global.run_from_editor = string_pos('gm_ttt',working_directory) != 0
global.editor_project_path = 'D:\develop\game maker studio\jtool-qa\source.gmx'
// add backslash to end
if string_char_at(global.editor_project_path,string_length(global.editor_project_path)) != '\' {
    global.editor_project_path += '\'
}
if global.run_from_editor and not FS_directory_exists(global.editor_project_path) {
    show_message("The editor project path you specified doesnt exist!#Edit the variable in the misc/mainInit script.")
    game_end()
}

ex_patch_window_close_capture(true)

// 游戏开始时是否检查地图
// 防呆，消耗一点时间，发布时可关闭
global.canCheckMaps = true;
defineMaps();
global.nowMapIndex = -1;
global.timeLeft = -1;
global.questionTip = "";

global.playback = false;
global.flashAnswerDelay = -1;
global.flashTimeLeft = -1;
global.flashCountLeft = 0;
global.flashEndDelay = -1;
global.answerObjectsPosMap = ds_map_create();
global.nextMapDelay = -1;
global.playerScore = 0;
global.showScore = false;
global.answerInstances = array_create(0);

global.answerCount = 0;
global.playerAnswerCount = 0;
global.playerScores = array_create(0);

// global state
global.state = globalstate_idle
global.comboboxselected = false
global.count = 0
global.frameaction_jump = false
global.frameaction_djump = false
global.frameaction_jumpslow = false
global.player_xscale = 1 // setting the player's xscale causes physics issues
global.joketitleindex = 0 // used in buttonCallback_JokeTitle
global.version_major = 1
global.version_minor = 3
global.version_patch = 5
global.version_string = string(global.version_major)+'.'+string(global.version_minor)+'.'+string(global.version_patch)
global.input_string = ''
global.input_bool = false
global.input_cancel = false
global.depthList = ds_list_create()
global.waterlocked = false
global.backup_period = 5*60*50
alarm[5] = global.backup_period
global.BackupFailSafe = false
global.shouldresetloadedmapname = false

// maybe later load from map
global.grav = 1
global.saveGrav = 1

// might load from config later
global.killer_holdduration = 12
global.killer_fadeduration = 4
global.restartWithDJump = true;
global.checkNudgeEarly = true;

loadConfig()

if (global.canCheckMaps) {
    checkMaps();
}
nextMap();

// misc
randomize()
display_set_gui_size(view_wport,view_hport)
window_set_caption('jtool')
// load keys from file sometime? idk
global.key_left = vk_left
global.key_right = vk_right
global.key_up = vk_up
global.key_down = vk_down
global.key_jump = vk_shift
global.key_shoot = ord('Z')
global.key_restart = ord('R')
global.key_suicide = ord('Q')
global.key_pause = vk_escape
global.record = false; // 0=noone,1=record,2=play

global.recordList = ds_list_create();
global.recordX = 0;
global.recordY = 0;
global.recordGrav = 1;
global.recordXscale = 1;
global.recordVspeed = 0;
global.recordDjump = true
global.continueclicked = false
global.pausedX = 0
global.pausedY = 0
global.pausedgrav = 1
global.pausedplayer_xscale = 1
global.pausedVspeed = 0
global.pausedDjump = true

//Record Save State Variables
global.recordListSS5 = ds_list_create()
global.recordListSS6 = ds_list_create()
global.recordListSS7 = ds_list_create()
global.recordListSS8 = ds_list_create()
global.recordListSS9 = ds_list_create()
global.recordListSS10 = ds_list_create()
global.recordListSS11 = ds_list_create()
global.recordListSS12 = ds_list_create()

for (var i = 1; i < 101; i +=1) {
global.recordListRewind[i] = ds_list_create() }

codable_initialize()
