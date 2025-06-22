class_name PlayerPlatformerSerializableComponent 
extends ASerializableComponent

var _playerPlatformer: PlayerPlatformer

func _init(playerPlatformer: PlayerPlatformer) -> void:
	_playerPlatformer = playerPlatformer
	
func on_save_game(saved_data: Array[SavedData]):
	var my_data = PlayerPlatformerSavedData.new()
	my_data.position = _playerPlatformer.position
	my_data.scene_path = ""
	my_data.num_of_lives = GameManagerSingleton.num_of_lives
	my_data.health = GameManagerSingleton.health
	my_data.num_of_coins =  GameManagerSingleton.num_of_coins
	var inventory_items_copy = GameManagerSingleton.inventory.get_items().duplicate(true)
	my_data.inventory_items = inventory_items_copy
	my_data.level_start_ticks = GameManagerSingleton.level_start_ticks
	my_data.num_of_coins_before_killed = GameManagerSingleton.num_of_coins_before_killed
	my_data.pause_ticks = Time.get_ticks_msec()
	my_data.currently_used_items_saved_data.clear()
	
	for cui in GameManagerSingleton.currently_used_items.get_cu_items():
		var cuisd = CurrentlyUsedItemSavedData.new()
		cuisd.from_currently_used_item(cui)
		my_data.currently_used_items_saved_data.append(cuisd)
	
	saved_data.append(my_data)
	
func on_before_load_game():
	pass

func on_load_game(saved_data: SavedData):
	_playerPlatformer.position = saved_data.position
	
	if(saved_data is PlayerPlatformerSavedData):
		var my_data = saved_data as PlayerPlatformerSavedData
		GameManagerSingleton.num_of_lives = my_data.num_of_lives
		GameManagerSingleton.health = my_data.health
		GameManagerSingleton.num_of_coins = my_data.num_of_coins
		var now_ticks = Time.get_ticks_msec()
		var diff_ticks = my_data.pause_ticks - my_data.level_start_ticks
		GameManagerSingleton.level_start_ticks = now_ticks - diff_ticks
		GameManagerSingleton.num_of_coins_before_killed = my_data.num_of_coins_before_killed
		var inventory_items_copy = my_data.inventory_items.duplicate(true)
		GameManagerSingleton.inventory.set_items(inventory_items_copy) 
		GameManagerSingleton.currently_used_items.clear()
		
		for cuisd: CurrentlyUsedItemSavedData in my_data.currently_used_items_saved_data:
			var cui: CurrentlyUsedItem = cuisd.to_currently_used_item()
			GameManagerSingleton.currently_used_items.add_cu_item(cui)
