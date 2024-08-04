extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Object related variables
@export_category("Objects")
@export var spawner_margin: int = 70
@export var spawn_rate: float = Global.spawn_time:
	# Spawn rate setter
	set(value):
		spawn_rate = value
		# Update the spawn timer
		$Timers/Spawn.wait_time = spawn_rate
	
# Map's scroll speed	
@export var scroll_speed: float = Global.scroll_speed:
	# Setter
	set(value):
		scroll_speed = value
		# Update road's scroll speed
		$Sprite.material.set_shader_parameter("scrollSpeed", scroll_speed)

# Scene variables
@export_category("Scenes")
# Scene with objects
@export var object_scene: PackedScene
# Explosion one
@export var explosion_scene: PackedScene
@export var enemy_explosion_scene: PackedScene
# Enemy object
@export var enemy_scene: PackedScene


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready() -> void:
	"""Initialize the map"""
	# Save every road position
	for road in $Roads.get_children():
		Global.roads.append(road.global_position)
		
	# Set the correct spawn time
	$Timers/Spawn.wait_time = Global.spawn_time
		
	# Save road count
	Global.last_road_index = $Roads.get_child_count() - 1
	
	# Place correctly all the spawners
	for index in $Spawners.get_child_count():
		$Spawners.get_child(index).position[1] = Global.roads[index][1]
		
	# Connect proper explosion function to the signal
	$Entities/Player.connect("explode", _create_explosion)
	
	# Make sure to update the stats when they are changed
	Global.connect("stats_changed", _update_stats)
		
func _process(_delta: float) -> void:
	"""Process map changes over time"""
	# If spawn cooldown passed, create an object
	if not $Timers/Spawn.time_left:
		# Spawn objects with a 70% chance
		if (randi_range(0, 9) < 7):
			_spawn_objects()
		# Spawn enemies with a 30% chance
		else:
			_spawn_enemies()
	
"""---------------------------- USER-DEFINED FUNCTIONS ----------------------------"""
func _spawn_objects() -> void:
	"""Spawn random objects"""
	# Object type index
	var object_type_index: int = randi_range(0, Global.objects.size() - 1)
	
	# Choose object type and if it's destroyed
	var object_type: String = Global.objects.keys()[object_type_index]
	var destroyed: bool = bool(randi_range(0, 1))
	
	# Choose a random place to spawn the object
	var random_spawner: Marker2D = \
		$Spawners.get_child(randi_range(0, $Spawners.get_child_count() - 1))
	
	# Create the object
	var object = object_scene.instantiate()
	# Set the correct variables related to it
	object.type = object_type
	object.destroyed = destroyed
	
	# Set correct position
	object.global_position = random_spawner.global_position
	
	# Add it to the objects
	$Objects.add_child(object)
	
	# Start the cooldown
	$Timers/Spawn.start()
	
func _spawn_enemies() -> void:
	"""Spawn the enemies"""
	# Index of the enemy type
	var enemy_index: int = randi_range(0, Global.enemies.size() - 1)
	
	# Get the enemy type
	var enemy_type: String = Global.enemies.keys()[enemy_index]
	
	# Choose a random place to spawn it
	var random_spawner: Marker2D = \
		$Spawners.get_child(randi_range(0, $Spawners.get_child_count() - 1))
		
	# Create the enemy
	var enemy = enemy_scene.instantiate()
	
	# Set its type
	enemy.type = enemy_type
	# Set the position
	enemy.global_position = random_spawner.global_position
	
	# Connect the correct signal
	enemy.connect("enemy_explode", _enemy_explosion)
	
	# Add it to the map
	$Entities/Enemies.add_child(enemy)
	
	# Start the cooldown
	$Timers/Spawn.start()
	
func _create_explosion(pos: Vector2, type: int) -> void:
	"""Create explosion when needed"""
	# Create an explosion scene, add it to the current one
	var explosion = explosion_scene.instantiate()
	$Effects.add_child(explosion)
	
	# Set its position
	explosion.position = pos
	# Set its type
	explosion.explosion_type = type
	
	if type == 0:
		explosion.play("Normal")
	else:
		explosion.play("Huge")
		
func _enemy_explosion(pos: Vector2) -> void:
	"""Create explosion made by the enemy"""
	# Create it
	var enemy_explosion = enemy_explosion_scene.instantiate()
	$Effects.add_child(enemy_explosion)
	
	# Set the position
	enemy_explosion.position = pos
	
	# Wait for the explosion to end
	await enemy_explosion.animation_finished
	
func _update_stats() -> void:
	"""Update the current statistics"""
	spawn_rate = Global.spawn_time
	scroll_speed = Global.scroll_speed
