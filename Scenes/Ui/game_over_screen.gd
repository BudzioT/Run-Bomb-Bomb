extends Control

"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready() -> void:
	"""Initialize the game over screen"""
	$ScoreLabel.text = str(Global.score)

func _start_pressed() -> void:
	"""Handle player pressing the play button"""
	Global.start_game()
	get_tree().change_scene_to_file("res://Scenes/Levels/map.tscn")
