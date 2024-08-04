extends Node


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

# Speed of map scroll
const scroll_speed: float = 1.0

# Difficulty increase
var difficulty_increase: float = 1.1

# Array of road positions
var roads = []

# Player's score
var score = 0

# Speed of enemy objects
var enemy_speed = {
	"Dynamite": 300,
	"Bullet": 400
}
