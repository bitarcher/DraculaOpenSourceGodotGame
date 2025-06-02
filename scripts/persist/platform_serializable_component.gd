class_name PlatformSerializableComponent
extends ASerializableComponent

func _get_platform() -> Node2D:
	return get_parent()
	
func on_save_game(saved_datas):
	var platform = _get_platform()
	var my_data: PlatformSavedData = PlatformSavedData.new()
	my_data.scene_path = "res://scenes/platform.tscn"
	my_data.position = platform.position
	
	var animation_players = ToolsSingleton.get_nodes_from_class(platform, "AnimationPlayer")
	
	if(len(animation_players) > 0):
		my_data.use_animation = true
		var animation_player: AnimationPlayer = animation_players[0]
		
		my_data.savable_animation_player_config.capture_from_animation_player(animation_player)
	
	saved_datas.append(my_data)
	
func on_before_load_game():
	var platform = _get_platform()
	platform.get_parent().remove_child(platform)
	platform.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var platform = _get_platform()
	
	if(my_saved_data is PlatformSavedData):
		var my_data = my_saved_data as PlatformSavedData
		platform.position = platform.position		
		
		if(my_data.use_animation):
			var animation_player = AnimationPlayer.new()
			my_data.savable_animation_player_config.apply_to_animation_player(animation_player, platform)
			platform.add_child(animation_player)
		
			
			
