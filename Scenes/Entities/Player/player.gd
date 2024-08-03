extends CharacterBody2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
@export_category("Movement")
@export var speed: int = 200
var direction: Vector2

# Current road index that player's on
var road_index: int = 0

# Player's height
@export var height: int = 50

# Vertical movement flag
var vertical_movement: bool = false
# Direction of vertical movement
var vertical_direction: int = 0


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _physics_process(_delta: float) -> void:
	"""Process player's changes"""
	# Handle input
	_handle_input()
	
	# Move the player
	_move()
	
	print(position)

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
		# Create a tween for moving vertically
		var newPos = Global.roads[road_index].y - int(float(height) / 2)
		var tween = create_tween()
		tween.tween_property(self, "position:y", newPos, Global.scroll_speed)
		vertical_movement = false
		
	# Stop vertical movement
	direction.y = 0
		
	# Update velocity
	velocity = direction * speed
		
func _move():
	"""Handle player's movement"""
	# Apply movement
	move_and_slide()
