extends CharacterBody2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
@export_category("Movement")
@export var verticalSpeed = 400
@export var horizontalSpeed = 200
var direction: Vector2

# Current road index that player's on
var road_index = 1


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _physics_process(delta: float) -> void:
	"""Process player's changes"""
	_handle_input()
	

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _handle_input():
	"""Handle player related input"""
	# Get direction
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	# Handle vertical movement
	if direction.y:
		# Update current road index
		road_index += direction.y
		
		# Make sure it's in bounds
