class_name SaverLoader
extends Node


func save_game(address: String = "user://savegame.tres"):
	var saved_game : SavedGame = SavedGame.new()
	
	var saved_data: Array[SavedData] = []
	get_tree().call_group("Serializable", "on_save_game", saved_data)
	saved_game.saved_datas = saved_data
	
	ResourceSaver.save(saved_game, address)
	
func load_game(address: String = "user://savegame.tres"):
	var saved_game: SavedGame = load(address) as SavedGame
	
	get_tree().call_group("Serializable", "on_before_load_game")
	for item in saved_game.saved_datas:
		if(item.scene_path != null):
			var scene = load(item.scene_path) as PackedScene
			var restored_node = scene.instantiate()
			get_tree().root.add_child(restored_node)
			var serializable_component = restored_node.get_node("SerializableComponent") as ASerializableComponent
			assert(serializable_component != null)
			serializable_component.on_load_game(item)
