extends Node2D


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Initialize the map"""
	print("INIT")
	# Save every road position
	for road in $Roads.get_children():
		Global.roads.append(road.global_position)
		
	# Save road count
	Global.last_road_index = $Roads.get_child_count() - 1
