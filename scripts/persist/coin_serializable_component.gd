class_name CoinSerializableComponent
extends ASerializableComponent

func _get_coin() -> Coin:
	return get_parent()
	
func on_save_game(saved_datas):
	var coin = _get_coin()
	
	if not coin.visible:
		return
		
	var my_data = SlimeEnemySavedData.new()
	my_data.scene_path = "res://scenes/coin.tscn"
	my_data.position = coin.global_position
	
	saved_datas.append(my_data)
	
func on_before_load_game():
	var coin = _get_coin()
	coin.get_parent().remove_child(coin)
	coin.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var coin = _get_coin()
	coin.global_position = my_saved_data.position
	
		
		
