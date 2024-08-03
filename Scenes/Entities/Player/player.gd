extends CharacterBody2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
@export_category("Movement")
@export var speed: int = 100
var direction: Vector2

# Current road index that player's on
var road_index: int = 1

# Vertical movement flag
var vertical_movement: bool = false
# Direction of vertical movement
var vertical_direction: int = 0


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _physics_process(delta: float) -> void:
	"""Process player's changes"""
	# Handle input
	_handle_input()
	
	# Move the player
	_move()

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _handle_input():
	"""Handle player related input"""
	# Get direction
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	# Handle vertical movement
	if direction.y and not $Timers/RoadCooldown.time_left and not vertical_movement:
		print(direction)
		
		# Make sure index isn't too low
		if direction.y < 0:
			road_index = max(0, road_index - 1)
			vertical_direction = -1
		# And it isn't too high
		else:
			road_index = min(Global.last_road_index, road_index + 1)
			vertical_direction = 1
		
		# Start the cooldown
		$Timers/RoadCooldown.start()
		
		vertical_movement = true
	
	# If player's moving vertically, keep him accelerated
	if vertical_movement:
		direction.y = vertical_direction
		
	# Update velocity
	velocity = direction * speed
		
func _move():
	"""Handle player's movement"""
	# If player wants to move horizontally
	if velocity.y:
		if position.y == \
			Global.starting_point + road_index * (Global.road_size + Global.road_margin):
			# Stop moving if position is already good
			velocity.y = 0
			vertical_movement = false
	
	# Apply movement
	move_and_slide()
