extends AnimatedSprite2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
func _ready() -> void:
	"""Initialize the explosion"""
	pass
	
func _animation_finished() -> void:
	"""Make the explosion dissapear after finishing its animation"""
	queue_free()
