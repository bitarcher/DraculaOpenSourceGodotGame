class_name SlideEnemySerializableComponent
extends ASerializableComponent

func _get_slime_enemy() -> SlimeEnemy:
	return get_parent()
	
func on_save_game(saved_datas):
	var slime_enemy = _get_slime_enemy()
	var my_data = SlimeEnemySavedData.new()
	my_data.scene_path = "res://scenes/slime_enemy.tscn"
	my_data.position = slime_enemy.global_position
	my_data.direction = slime_enemy.direction
	my_data.flip_h = slime_enemy.animated_sprite.flip_h
	
	saved_datas.append(my_data)
	
func on_before_load_game():
	var slime_enemy = _get_slime_enemy()
	slime_enemy.get_parent().remove_child(slime_enemy)
	slime_enemy.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var slime_enemy = _get_slime_enemy()
	slime_enemy.global_position = my_saved_data.position
	
	if(my_saved_data is SlimeEnemySavedData):
		var my_data = my_saved_data as SlimeEnemySavedData
		slime_enemy.direction = my_data.direction
		slime_enemy.animated_sprite.flip_h = my_data.flip_h
		
		
