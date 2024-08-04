extends CharacterBody2D


"""---------------------------- SIGNALS ----------------------------"""
signal explode(pos: Vector2, type: int)


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
# Speed of vertical movement in time
var vertical_speed: float = Global.vertical_speed:
	# Set the time required to move
	set(value):
		vertical_speed = value

# Animations related variables
@export_category("Animations")
# Idle state flag
@export var state: String = "Run"

@export_category("Game")
# Number of explosions left
@export var explosions: int = 5

# Death flag
var death: bool = false
# Movement ability flag
var can_move: bool = true


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _ready():
	"""Prepare the player"""
	state = "Run"
	
	# Connect the right signal, when stats change
	Global.connect("stats_changed", _update_stats)

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
	if vertical_movement and can_move:
		# Set the correct state, if player isn't attacking
		if not state.find("_Attack"):
			state = "Jump"
		
		# Calculate proper player's position on the new track
		var newPos = Global.roads[road_index].y - int(float(height) / 2)
		
		# Create a tween for moving vertically
		var tween = create_tween()
		tween.tween_property(self, "position:y", newPos, vertical_speed)
	
		# On ending moving, return the animation to run
		tween.tween_callback(_run)
		
		# Vertical movement is finished, turn off the flag
		vertical_movement = false
		
	# Stop vertical movement
	direction.y = 0
	
	# Check for attacks
	if Input.is_action_just_pressed("Attack") and not $Timers/AttackCooldown.time_left:
		_handle_attack()
	
		
func _move():
	"""Handle player's movement"""
	if can_move:
		# Update velocity
		velocity = direction * speed
		
		# Apply movement
		move_and_slide()
	
func _handle_attack():
	"""Make the player attack"""
	# If player can explode
	if explosions > 0:
		# Set the animation to attack one
		state += "_Attack"
		
		# Make sure this is the right state
		if (state == "_Attack"):
			state = "Idle_Attack"
			
		# Start emitting particles
		$Particles/AttackParticles.emitting = true
		
		# Play the animation
		$AnimationPlayer.play(state)
		
		# Activate attack cooldown
		$Timers/AttackCooldown.start()
	
func _animate():
	"""Animate the player"""
	# If attack animation isn't finished, return
	if state.find("_Attack"):
		if not $AnimationPlayer.animation_finished:
			return
			
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
	# Wait for the animation to finish
	await $AnimationPlayer.animation_finished
	
	# Set run state
	state = "Run"
	
func _explode():
	"""Explode the bomb"""
	# Emit particles
	
	# Choose a type
	var type: int = 0
	# If amount is high enough, choose the longer one
	if explosions > 3:
		type = 1
		
	# Emit explosion signal
	explode.emit(position, type)
	
	# Decrease the amount of explosions
	# explosions -= 1
	
func hit():
	"""Hit the player"""
	# Set the flag
	death = true
	
	# Emit death particles
	$Particles/DeathParticles.emitting = true
	
	# Play hit sound
	$HitSound.play()
	
	# Make the player unable to move
	can_move = false
	
	# Wait some time
	$Timers/AttackCooldown.start()
	await $Timers/AttackCooldown.timeout
	
	# Show the game over screen
	get_tree().change_scene_to_file("res://Scenes/Ui/game_over_screen.tscn")
	
func _update_stats():
	"""Update statistics related to the player"""
	vertical_speed = Global.vertical_speed
