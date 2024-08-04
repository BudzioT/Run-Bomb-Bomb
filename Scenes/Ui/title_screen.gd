extends Control


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _start_pressed() -> void:
	"""Handle player pressing the play button"""
	Global.start_game()
	get_tree().change_scene_to_file("res://Scenes/Levels/map.tscn")


func _quit_pressed() -> void:
	"""Handle player pressing the quit button"""
	get_tree().quit()
