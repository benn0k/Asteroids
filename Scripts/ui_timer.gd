extends Panel

var time:= 0.0
var minutes := 0
var seconds := 0
var msec:= 0
var score := 0


func _ready() -> void:
	%Button.connect("pressed", _on_Button_pressed)

# Count up the timer 
func _process(delta: float) -> void:
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time,3600) / 60
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d:" % seconds
	$Msecs.text = "%03d" % msec


# When ship is destroyed, stop the timer
func _on_ship_destroyed() -> void:
	set_process(false)


# When an asteroid leaves the spawner (or, when it despawns), increment score
func _on_random_item_spawner_child_exiting_tree(_node:Node) -> void:
	score += 1
	$Score.text = 'SCORE: ' + str(score)

# When Restart is pressed, do this
func _on_Button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
