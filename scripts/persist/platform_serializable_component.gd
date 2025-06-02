class_name PlatformSerializableComponent
extends ASerializableComponent

func _get_platform() -> Node2D:
	return get_parent()
	
func on_save_game(saved_datas):
	var platform = _get_platform()
	var my_data: PlatformSavedData = PlatformSavedData.new()
	my_data.scene_path = "res://scenes/platform.tscn"
	
	var animation_players = ToolsSingleton.get_nodes_from_class(platform, "AnimationPlayer")
	
	if(len(animation_players) > 0):
		# When an animation is used, we save the GLOBAL position.
		# This is because the animation might be relative to the platform's local position,
		# but we want to restore the platform's absolute world location.
		my_data.position = platform.global_position 
		my_data.use_animation = true
		var animation_player: AnimationPlayer = animation_players[0]
		
		my_data.savable_animation_player_config.capture_from_animation_player(animation_player)
	else:
		# If no animation is used, we also save the GLOBAL position.
		# This ensures 'my_data.position' always holds a consistent global coordinate.
		my_data.position = platform.global_position
		
	saved_datas.append(my_data)
	
func on_before_load_game():
	var platform = _get_platform()
	platform.get_parent().remove_child(platform)
	platform.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var platform = _get_platform() # This gets the platform node itself
	
	if(my_saved_data is PlatformSavedData):
		var my_data = my_saved_data as PlatformSavedData
		
		# Always restore the platform's GLOBAL position first.
		# This places the platform at its saved world location.
		platform.global_position = my_data.position

		if(my_data.use_animation):
			# Try to get an existing AnimationPlayer on the platform.
			var animation_player: AnimationPlayer = ToolsSingleton.get_node_from_class(platform, "AnimationPlayer")

			if animation_player == null:
				# If no AnimationPlayer exists, create a new one.
				animation_player = AnimationPlayer.new()
				# Ensure the AnimationPlayer is added as a child of the platform.
				# This is crucial for relative node paths in animations to work correctly.
				platform.add_child(animation_player)
				# Set the owner for proper scene integration and saving
				animation_player.owner = platform 
				
			# Apply the saved animation configuration to the AnimationPlayer.
			# 'platform' is generally the correct 'animated_object' here if animations
			# are tracking properties on the 'platform' node itself or its direct children.
			my_data.savable_animation_player_config.apply_to_animation_player(animation_player, platform)
			
			# Critical: If the animation itself changes the platform's LOCAL position,
			# you need to ensure the animation *starts* from the correct local offset.
			# This is complex and depends heavily on how your animations are designed.
			#
			# One common pattern: If your animation is a loop (e.g., oscillating platform),
			# and it animates 'position' relative to its parent (the Platform node itself),
			# then setting 'platform.global_position' beforehand should be sufficient.
			# The animation will then run relative to this global starting point.
			#
			# If your animation is designed to move the *entire* platform from one global
			# point to another, then the animation might be tracking the 'global_position'
			# (which is less common for typical animations) or relies on the AnimationPlayer's
			# parent being at (0,0) and animating its own global position (also rare).
			#
			# For most animations (like oscillating platforms), the animation keyframes
			# are relative to the node that the AnimationPlayer is attached to.
			# By setting the platform's global position *before* applying the animation,
			# the animation should then play correctly from that new world origin.

		# If not using animation, platform.global_position is already set above.
		# This 'else' block effectively becomes empty.
