extends Node2D

#set this constant before game start
const in_edit_mode: bool = false
var current_level_name = "TWINKLE_TWINKLE_LITTLE_STAR"

#time it takes for falling key to reach critical spot
var fk_fall_time: float = 2.2
var fk_output_arr = [[], [], [], []]

var level_info = {
	"TWINKLE_TWINKLE_LITTLE_STAR" = {
		"fk_times": "[[-0.94167799949646, -0.32344670295715, 3.03165512084961, 3.59473924636841, 11.9684350967407, 17.8895233154297, 26.9249885559082, 27.575146484375, 33.185669708252, 33.6239440917969, 39.6292045593262, 41.9424942016602, 47.8519714355469, 55.2533348083496, 56.9193656921387, 57.613060760498, 59.9147384643555, 62.9333312988281, 63.5428588867187], [-1.57750566005707, -0.14811782836914, 4.33197288513184, 5.07791404724121, 12.5982769012451, 14.8390014648438, 15.6168716430664, 18.551293182373, 23.8425395965576, 28.3326976776123, 29.0902488708496, 31.3832214355469, 34.3263481140137, 35.072289276123, 41.1094787597656, 48.5979125976562, 53.7933776855469, 54.5828559875488, 61.3340576171875, 64.3323333740234, 65.1102035522461], [-0.98113374710083, 0.66321997642517, 6.58140544891357, 9.0136964797974, 9.5680721282959, 13.3442180633545, 16.3628108978271, 17.1435821533203, 19.2856243133545, 22.3593643188477, 23.105305480957, 24.6204078674316, 30.6256683349609, 35.9053047180176, 37.3768699645996, 38.9035842895508, 43.2979591369629, 46.3165519714355, 47.0944221496582, 49.3438537597656, 52.2463500976562, 53.1199996948242, 58.4112480163574, 59.1165550231934, 65.8242156982422, 66.6369140625], [1.46140604019165, 5.87900238037109, 7.35056667327881, 10.3488433837891, 11.1470296859741, 20.9835823059082, 21.6221321105957, 25.3141048431396, 29.8565071105957, 36.6947830200195, 40.331608581543, 42.6158721923828, 44.9726989746094, 45.5706108093262, 50.9344223022461, 51.5439460754395, 60.6200454711914, 67.3625381469727]]",
		"music": load("res://music/white_records-twinkle-twinkle-little-star-bells-background-xmas-music-for-video-262281.wav")
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MusicPlayer.stream = level_info.get(current_level_name).get("music")
	$MusicPlayer.play()
	
	if in_edit_mode:
		Signals.KeyListenerPress.connect(KeyListenerPress)
	else:
		var fk_times = level_info.get(current_level_name).get("fk_times")
		var fk_times_arr = str_to_var(fk_times)
		
		var counter: int = 0
		for key in fk_times_arr:
			
			var button_name: String = ""
			match counter:
				0:
					button_name = "button_Q"
				1:
					button_name = "button_W"
				2:
					button_name = "button_E"
				3:
					button_name = "button_R"
			
			for delay in key:
				SpawnFallingKey(button_name, delay)
				
			counter += 1

func KeyListenerPress(button_name: String, array_num: int):
	#print(str(array_num) + " " + str($MusicPlayer.get_playback_position()))
	fk_output_arr[array_num].append($MusicPlayer.get_playback_position() - fk_fall_time)
	

func SpawnFallingKey(button_name: String, delay: float):
	await get_tree().create_timer(delay).timeout
	Signals.CreateFallingKey.emit(button_name)


func _on_music_player_finished() -> void:
	print(fk_output_arr)
