extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Type of enemy object
@export_enum("Dynamite", "Bullet") var type: String = "Dynamite"

# Movement variables
@export_category("Movement")
@export var speed: int = 300


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _process(delta: float) -> void:
	"""Process enemy object's changes over time"""
	# Move the enemy depending on its speed
	position.x -= speed * delta
	
	# Remove it if its too far
	if position.x < -100:
		queue_free()
