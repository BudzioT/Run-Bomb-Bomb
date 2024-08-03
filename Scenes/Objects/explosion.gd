extends AnimatedSprite2D


# Animation related variables
@export_category("Animation")
@export var explosion_type: int = 0:
	# Setter
	set(value):
		# If a value exists, choose the correct animation
		if value:
			if explosion_type == 0:
				animation = "Normal"
			else:
				animation = "Huge"


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready() -> void:
	"""Initialize the explosion"""
	explosion_type = 0
	print("CREATED")
	
func _animation_finished() -> void:
	"""Make the explosion dissapear after finishing its animation"""
	queue_free()
	# Make the explosion dissapear
	Global.explode = false
	print("DESTROYED")
	
func _attack_area_entered(body: Node2D) -> void:
	"""Handle object entering player's attack area"""
	# If there is currently an explosion going on
	if Global.explode:
		# If the object is already partially destroyed, make it dissapear
		if body.destroyed:
			body.queue_free()
			Global.score += 20
		# Otherwise set its state to destroyed
		else:
			body.destroyed = true
			Global.score += 10
