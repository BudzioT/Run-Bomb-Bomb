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
	
func _animation_finished() -> void:
	"""Make the explosion dissapear after finishing its animation"""
	queue_free()
	
func _attack_area_entered(body: Node2D) -> void:
	"""Handle object entering player's attack area"""
	# If the object is already partially destroyed, make it dissapear
	if body.get_parent().get_parent().destroyed:
		body.queue_free()
		Global.score += Global.score_destroyed_increase
	# Otherwise set its state to destroyed
	else:
		body.get_parent().get_parent().destroyed = true
		Global.score += Global.score_normal_increase
