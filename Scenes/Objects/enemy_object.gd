extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
signal enemy_explode(pos: Vector2)


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Type of enemy object
@export_enum("Dynamite", "Bullet") var type: String = "Dynamite":
	# Setter
	set(value):
		if value:
			type = value
			
			# Hide all enemy object
			for enemy in $Options.get_children():
				enemy.get_node("Collision").disabled = true
				enemy.hide()
				
			# Show the correct enemy
			var currentEnemy = $Options.get_child(Global.enemies[type])
			currentEnemy.show()
			currentEnemy.get_node("Collision").disabled = false
			
			speed = Global.enemy_speed[type]

# Movement variables
@export_category("Movement")
@export var speed: int = 300


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready() -> void:
	"""Prepare the enemy object"""
	# Connect the right function to update stats
	Global.connect("stats_changed", _update_stats)

func _process(delta: float) -> void:
	"""Process enemy object's changes over time"""
	# Move the enemy depending on its speed
	position.x -= speed * delta
	
	# Remove it if its too far
	if position.x < -100:
		queue_free()

func _dynamite_entered(body: Node2D) -> void:
	"""Handle player hitting the dynamite"""
	_deal_damage(body)

func _bullet_entered(body: Node2D) -> void:
	"""Handle bullet hitting the player"""
	_deal_damage(body)
	
"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _deal_damage(body: Node2D) -> void:
	"""Damage the entity"""
	# Emit signal to explode
	enemy_explode.emit(position)
	
	# Hit the body, if it's possible
	if body.has_method("hit"):
		body.hit()
		
	# Remove the enemy
	queue_free()
	
func _update_stats() -> void:
	"""Update enemy's stats"""
	speed = Global.enemy_speed[type]
