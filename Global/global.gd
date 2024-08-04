extends Node


"""---------------------------- SIGNALS ----------------------------"""
signal stats_changed()


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Dictionary of objects
const objects = {
	"Crate": 0,
	"Barrel": 1,
	"Lamp": 2,
	"FireHydrant": 3
}
# Dictionary of enemies
const enemies = {
	"Dynamite": 0,
	"Bullet": 1
}

# Last road index
var last_road_index: int = 3

# Road size
var road_size: Vector2
# Starting point of the player in pixels
const starting_point: int = 131

# Array of road positions
var roads = []

# Speed of map scroll
var scroll_speed: float = 0.2

# Current difficulty level
var difficulty: float = 1.0
# Difficulty increase
var difficulty_increase: float = 1.2
# Score goal to increase it
var diffculty_time: int = 100

# Speed of enemy objects
var enemy_speed = {
	"Dynamite": 300,
	"Bullet": 400
}
# Normal objects speed
var objects_speed: int = 300
# Player vertical speed in time
var vertical_speed: float = 1.0

# Score increase values
var score_normal_increase: int = int(10)
var score_destroyed_increase: int = int(20)

# Spawn time of the enemies
var spawn_time: float = 2.0


# Begin statistics of the game
const begin_stats = {
	"difficulty_time": 100,
	"score_normal": 10,
	"score_destroyed": 20,
	"spawn_time": 2.0,
	"objects_speed": 300,
	"Bullet_speed": 400,
	"Dynamite_speed": 300,
	"scroll_speed": 1.0,
	"vertical_speed": 1.0
}


# Player's score
var score = 0:
	# Setter of score
	set(value):
		score = value
		
		# If score is the right one, rise the difficulty
		if diffculty_time <= score:
			# Rise the difficulty barrier
			diffculty_time = int(begin_stats["difficulty_time"] * difficulty_increase \
				+ diffculty_time)
			# Increase current difficulty
			difficulty *= difficulty_increase
			
			# Increase score earned
			score_normal_increase *= int(begin_stats["score_normal"] * (difficulty - 0.1))
			score_destroyed_increase = int(begin_stats["score_destroyed"] * (difficulty - 0.1))
			
			# Decrease spawn time
			spawn_time = begin_stats["spawn_time"] - (0.1 * difficulty)
			
			# Increase speed of the enemies
			for enemy in enemy_speed.keys():
				enemy_speed[enemy] = int(begin_stats[enemy + "_speed"] * difficulty)
			# And the speed of objects
			objects_speed = int(begin_stats["objects_speed"] * difficulty)
			# Update player's speed too
			vertical_speed = max(begin_stats["vertical_speed"] / difficulty, 0.4)
			
			# Set the proper scroll speed
			scroll_speed = begin_stats["scroll_speed"] * difficulty + 0.1
			
			# Update the stats
			stats_changed.emit()
			
			print("STATS CHANGED")
		
		print(enemy_speed["Bullet"])


"""---------------------------- USER DEFINED FUNCTIONS ----------------------------"""
func start_game() -> void:
	"""Start the game"""
	pass
	
func end_game() -> void:
	"""End the game"""
	pass
