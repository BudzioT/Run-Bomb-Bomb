extends AnimatedSprite2D


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready() -> void:
	"""Prepare the explosion"""
	pass

func _animation_finished() -> void:
	"""End the explosion, after finishing the animation"""
	queue_free()
