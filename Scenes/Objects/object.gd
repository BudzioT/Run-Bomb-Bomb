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
			
			# Hide other objects
			for object in $Options.get_children():
				object.hide()
			
			# Show the correct one
			var current_object = $Options.get_child(Global.objects[type])
			current_object.show()
	
# Object is destroyed flag		
@export var destroyed: bool = false:
	# Setter
	set(value):
		# If there is properly set type and a correct value
		if type and value and get_child_count() > 0:
			destroyed = value
			
			# Hide the normal object if destroyed is the correct one
			if destroyed:
				$Options.get_child(Global.objects[type])
