extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(_event):
	if get_tree().paused && Input.is_key_pressed(KEY_ENTER):
		$"0/M/Viewport/Node2D".cur_lives=5
		$"0/M/Viewport/Node2D".points = 0
		$"0/M/Viewport/Node2D".point_mult = 1
		$"0/M/Viewport/Node2D".reload_menu()
		get_tree().paused=false
		$"0/M/Label".visible = false
