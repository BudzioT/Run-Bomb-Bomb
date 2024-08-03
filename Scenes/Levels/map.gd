extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Object related variables
@export_category("Objects")
@export var spawner_margin: int = 70
@export var spawn_rate: float = 2:
	# Spawn rate setter
	set(value):
		spawn_rate = value
		# Update the spawn timer
		$Timers/Spawn.wait_time = spawn_rate

# Scene with objects
@export var object_scene: PackedScene


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Initialize the map"""
	print("INIT")
	# Save every road position
	for road in $Roads.get_children():
		Global.roads.append(road.global_position)
		
	# Save road count
	Global.last_road_index = $Roads.get_child_count() - 1
	
	# Place correctly all the spawners
	for index in $Spawners.get_child_count():
		$Spawners.get_child(index).position[1] = Global.roads[index][1] + 70
		
func _process(_delta: float):
	"""Process map changes over time"""
	# If spawn cooldown passed, create an object
	if not $Timers/Spawn.time_left:
		_spawn_objects()
	
"""---------------------------- USER-DEFINED FUNCTIONS ----------------------------"""
func _spawn_objects():
	"""Spawn random objects"""
	# Object type index
	var object_type_index = randi_range(0, Global.objects.size() - 1)
	
	# Choose object type and if it's destroyed
	var objectType: String = Global.objects
	var destroyed: bool = bool(randi_range(0, 1))
	
	# Choose a random place to spawn the object
	var random_spawner: Marker2D = \
		$Spawners.get_child(randi_range(0, $Spawners.get_child_count() - 1))
	
	# Create the object
	var object = object_scene.instantiate()
	# Set the correct variables related to it
	object.type = objectType
	object.destroyed = destroyed
	
	# Set correct position
	object.global_position = random_spawner.global_position
	
	# Start the cooldown
	$Timers/Spawn.start()
