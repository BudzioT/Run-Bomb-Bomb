extends Area2D


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the road"""
	# Save road height
	Global.road_size = $CollisionShape2D.shape.get_rect().size
