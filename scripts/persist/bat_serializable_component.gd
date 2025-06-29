class_name BatSerializableComponent
extends ASerializableComponent

func _get_bat() -> Bat:
	return get_parent()
	
func on_save_game(saved_datas):
	var bat : Bat = _get_bat()
	
	if(bat.is_dying):
		return
	
	var my_data = BatSavedData.new()
	my_data.scene_path = "res://scenes/bat.tscn"
	my_data.position = bat.global_position
	my_data.direction_vector.x  = bat._direction_vector.x
	my_data.direction_vector.y  = bat._direction_vector.y
	my_data.awake = bat.awake
	my_data.go_left_once_awaken = bat.go_left_once_awaken
	my_data.health = bat.health
	
	saved_datas.append(my_data)
	
func on_before_load_game():
	var slime_enemy = _get_bat()
	slime_enemy.get_parent().remove_child(slime_enemy)
	slime_enemy.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var bat : Bat  = _get_bat()
	bat.global_position = my_saved_data.position
	
	if(my_saved_data is BatSavedData):
		var my_data = my_saved_data as BatSavedData
		
		bat._direction_vector.x = my_data.direction_vector.x
		bat._direction_vector.y = my_data.direction_vector.y
		bat.awake = my_data.awake
		bat.go_left_once_awaken = my_data.go_left_once_awaken
		bat.health = my_data.health
	
