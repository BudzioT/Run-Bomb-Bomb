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
				object.get_node("Collision").disabled = true
				object.get_node("CollisionDestroyed").disabled = true
				object.hide()
			
			# Show the correct one
			var current_object = $Options.get_child(Global.objects[type])
			current_object.show()
			current_object.get_node("Collision").disabled = false
			
			if destroyed:
				destroyed = true
			else:
				destroyed = false
	
# Object is destroyed flag		
@export var destroyed: bool = false:
	# Setter
	set(value):
		# If there is properly set type and a correct value
		if type and value != null and get_child_count() > 0:
			destroyed = value
			
			# Current object
			var object = $Options.get_child(Global.objects[type])
			
			# Hide the normal object if destroyed is the correct one
			if destroyed:
				# Hide the normal sprite and collisions
				object.get_node("Sprite").hide()
				object.get_node("Collision").set_deferred("disabled", true)
				object.get_node("Collision").hide()
				
				# Show the destroyed ones
				object.get_node("SpriteDestroyed").show()
				object.get_node("CollisionDestroyed").set_deferred("disabled", false)
				object.get_node("CollisionDestroyed").show()
			
			# Otherwise hide destroyed object and show normal one
			else:
				# Hide the normal sprite and collisions
				object.get_node("SpriteDestroyed").hide()
				object.get_node("CollisionDestroyed").set_deferred("disabled", true)
				object.get_node("CollisionDestroyed").hide()
				
				# Show the destroyed ones
				object.get_node("Sprite").show()
				object.get_node("Collision").set_deferred("disabled", false)
				object.get_node("Collision").show()

# Movement variables				
@export_category("Movement")
@export var speed: int = 300


"""---------------------------- BUILT-IN FUNCTIONS ----------------------------"""
func _process(delta: float) -> void:
	"""Process object's changes over frames"""
	# Move the object
	position.x -= speed * delta
	
	# If it's too far away, remove it
	if position.x < -100:
		queue_free()
