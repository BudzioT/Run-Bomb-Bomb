@tool
extends Node2D


"""---------------------------- GLOBAL VARIABLES ----------------------------"""
# Type of objects
@export_enum("Crate", "Barrel", "Lamp", "FireHydrant") var type: String = "Crate":
	# Object's setter
	set(value):
		# If there is a value, options were loaded, set the correct object type
		if value and get_child_count() > 0:
			type = value
			
			# Dictionary of objects
			const objects = {
				"Crate": 0,
				"Barrel": 1,
				"Lamp": 2,
				"FireHydrant": 3
			}
			
			# Hide other objects
			for object in $Options.get_children():
				object.hide()
			
			# Show the correct one
			var properObject = $Options.get_child(objects[type])
			properObject.show()
			
@export var destroyed: bool = false
