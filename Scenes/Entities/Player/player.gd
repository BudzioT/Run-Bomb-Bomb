extends CharacterBody2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
@export_category("Movement")
@export var speed: int = 200
var direction: Vector2

# Current road index that player's on
var road_index: int = 0

# Transformation variables
@export_category("Transformations")
# Player's height
@export var height: int = 50

# Vertical movement flag
var vertical_movement: bool = false
# Direction of vertical movement
var vertical_direction: int = 0

# Animations related variables
@export_category("Animations")
# Idle state flag
@export var state: String = "Run"


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the player"""
	state = "Run"

func _physics_process(_delta: float) -> void:
	"""Process player's changes"""
	if state != "Idle":
		# Handle input
		_handle_input()
	
		# Move the player
		_move()
		
		# Animate him
		_animate()

"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func _handle_input():
	"""Handle player related input"""
	# Get direction
	direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	# Handle vertical movement
	if direction.y and not $Timers/RoadCooldown.time_left and not vertical_movement:
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
		# Set the correct state
		state = "Jump"
		
		# Calculate proper player's position on the new track
		var newPos = Global.roads[road_index].y - int(float(height) / 2)
		
		# Create a tween for moving vertically
		var tween = create_tween()
		tween.tween_property(self, "position:y", newPos, 1.0 / Global.scroll_speed)
		# On ending moving, return the animation to run
		tween.tween_callback(_run)
		
		# Vertical movement is finished, turn off the flag
		vertical_movement = false
		
	# Stop vertical movement
	direction.y = 0
	
	# Check for attacks
	if Input.is_action_just_pressed("Attack") and not $Timers/AttackCooldown.time_left:
		_explode()
	
		
func _move():
	"""Handle player's movement"""
	# Update velocity
	velocity = direction * speed
	
	# Apply movement
	move_and_slide()
	
func _explode():
	"""Make the player attack"""
	# Play the attack animation
	state += "_Attack"
	$AnimationPlayer.play(state)
	
	# Activate attack cooldown
	$Timers/AttackCooldown.start()
	
func _animate():
	"""Animate the player"""
	# Play the run animation
	if state == "Run":
		$AnimationPlayer.play("Run")
	# Play idle one
	elif state == "Idle":
		$AnimationPlayer.play("Idle")
	# Jump animation
	elif state == "Jump":
		$AnimationPlayer.play("Jump")
		
func _run():
	"""Make the player run again"""
	state = "Run"
