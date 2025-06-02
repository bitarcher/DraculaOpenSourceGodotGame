class_name SaverLoader
extends Node

func _get_player() -> PlayerPlatformer:
	
	var result = null
	
	const NUM_OF_TRIES = 1000
	var counter = 0
	
	while(result == null and counter < NUM_OF_TRIES):
		var found_nodes = GameManagerSingleton.get_tree().get_nodes_in_group("Player")
		if(len(found_nodes) > 0):
			result =  found_nodes[0]
		#result = GameManagerSingleton.get_node("%Player")
		await GameManagerSingleton.get_tree().process_frame
		counter += 1
	
	
	if(result == null):
		GameManagerSingleton.dump_scene_tree()
		print("could not fetch player")
		
	return result	

#const DEFAULT_STORE_PATH = "user://savegame.tres"
const DEFAULT_STORE_PATH = "res://savegame.tres"

func save_game(address: String = DEFAULT_STORE_PATH):
	var saved_game : SavedGame = SavedGame.new()
	saved_game.current_level = GameManagerSingleton.current_level
	
	var saved_datas: Array[SavedData] = []
	
	var test_nodes = GameManagerSingleton.get_tree().get_nodes_in_group("Serializable")
	#print("Nœuds Serializable trouvés: ", test_nodes.size())
	for node in test_nodes:
		print("- ", node.name, " (", node.get_script().get_global_name() if node.get_script() else "no script", ")")
		var serializable_component = node as ASerializableComponent
		serializable_component.on_save_game(saved_datas)
	
	#GameManagerSingleton.get_tree().call_group("Serializable", "on_save_game", saved_datas)	
	
	if(test_nodes.size() == 0):
		GameManagerSingleton.dump_scene_tree()
	
	
	var player = await _get_player()
	
	assert(player!=null)
	var player_platformer_serializable_component: PlayerPlatformerSerializableComponent = PlayerPlatformerSerializableComponent.new(player)
	player_platformer_serializable_component.on_save_game(saved_datas)
	
	saved_game.saved_datas = saved_datas
	
	ResourceSaver.save(saved_game, address)
	
func is_player_platformer_saved_data(saved_data: SavedData) -> bool:
	return saved_data is PlayerPlatformerSavedData
	
func load_game(address: String = DEFAULT_STORE_PATH):
	var saved_game: SavedGame = load(address) as SavedGame
	
	if(saved_game == null):
		GameManagerSingleton.new_game()
		return
	
	GameManagerSingleton.load_level(saved_game.current_level)
	
	var player = await _get_player()
	assert(player != null)
	var player_platformer_serializable_component: PlayerPlatformerSerializableComponent = PlayerPlatformerSerializableComponent.new(player)
	
	
	GameManagerSingleton.get_tree().call_group("Serializable", "on_before_load_game")
	
	for item in saved_game.saved_datas:
		if(not item.scene_path.is_empty()):
			var scene = load(item.scene_path) as PackedScene
			var restored_node = scene.instantiate()
			GameManagerSingleton.get_tree().current_scene.add_child(restored_node)
			var test_nodes = ToolsSingleton.get_nodes_in_group_from_node(restored_node, "Serializable")
			#print("Nœuds Serializable trouvés: ", test_nodes.size())
			for node in test_nodes:
				print("- ", node.name, " (", node.get_script().get_global_name() if node.get_script() else "no script", ")")
				var serializable_component = node as ASerializableComponent
				assert(serializable_component != null)
				serializable_component.on_load_game(item)

	for sd in saved_game.saved_datas:
		if sd is PlayerPlatformerSavedData:
			var ppsd = sd as PlayerPlatformerSavedData
			player_platformer_serializable_component.on_load_game(ppsd)
				
