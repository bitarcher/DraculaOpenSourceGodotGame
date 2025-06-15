class_name PlatformsDelayedSerializableComponent 
extends ASerializableComponent
	
func _get_platforms_delayed() ->  Array[Node]:
	var root = get_tree().current_scene
	
	return ToolsSingleton.get_nodes_in_group_from_node(root, "PlatformDelayed")
	
func on_save_game(saved_data: Array[SavedData]):
	var platforms_delayed: Array[Node] = _get_platforms_delayed()
	var platforms_delayed_data = PlatformsDelayedSavedData.new()
	
	for pd_proto in platforms_delayed:
		if(pd_proto is PlatformDelayed):
			var pd = pd_proto as PlatformDelayed
			var pdd = PlatformDelayedSavedData.new()
			pdd.uid = pd.uid
			pdd.consumed = pd.consumed
			platforms_delayed_data.items.append(pdd)
	
	saved_data.append(platforms_delayed_data)
	
func on_before_load_game():
	pass
	

func on_load_game(saved_data: SavedData):
	var platforms_delayed: Array[Node] = _get_platforms_delayed()
	
	if (saved_data is PlatformsDelayedSavedData):
		var platforms_delayed_data = saved_data as PlatformsDelayedSavedData
		for pd_proto in platforms_delayed:
			if(pd_proto is PlatformDelayed):
				var pd = pd_proto as PlatformDelayed
				var pdd = platforms_delayed_data.items.filter(func(pdd2):
					return 	pdd2.uid == pd.uid
				)
				
				if (pdd!= null):
					if(pdd.consumed):
						pd.go_straight_to_consumed_state()
		
