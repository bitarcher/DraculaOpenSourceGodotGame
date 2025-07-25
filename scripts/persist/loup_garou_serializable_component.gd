class_name LoupGarouSerializableComponent
extends ASerializableComponent

func _get_loup_garou() -> LoupGarou:
	return get_parent()
	
func on_save_game(saved_datas):
	var loup_garou = _get_loup_garou()
	
	if loup_garou.is_dying:
		return
	
	var my_data = LoupGarouSavedData.new()
	my_data.scene_path = "res://scenes/loup_garou.tscn"
	my_data.position = loup_garou.global_position
	my_data.current_direction = loup_garou.current_direction
	my_data.current_state = loup_garou.current_state
	my_data.flip_h = loup_garou.animated_sprite.flip_h
	my_data.health = loup_garou.health
	
	saved_datas.append(my_data)
	
func on_before_load_game():
	var loup_garou = _get_loup_garou()
	loup_garou.get_parent().remove_child(loup_garou)
	loup_garou.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var loup_garou = _get_loup_garou()
	loup_garou.global_position = my_saved_data.position
	
	if(my_saved_data is SlimeEnemySavedData):
		var my_data = my_saved_data as SlimeEnemySavedData
		loup_garou.current_direction = my_data.current_direction 
		loup_garou.current_state = my_data.current_state
		loup_garou.animated_sprite.flip_h = my_data.flip_h
		loup_garou.health = my_data.health
		
