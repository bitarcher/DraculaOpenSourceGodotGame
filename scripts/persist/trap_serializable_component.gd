class_name TrapSerializableComponent
extends ASerializableComponent

func _get_trap() -> Trap:
	return get_parent()
	
func on_save_game(saved_datas):
	var trap = _get_trap()
	var my_data = TrapSavedData.new()
	my_data.scene_path = "res://scenes/trap.tscn"
	my_data.position = trap.global_position
	my_data.consumed = trap.consumed
	
	saved_datas.append(my_data)
	
func on_before_load_game():
	var trap = _get_trap()
	trap.get_parent().remove_child(trap)
	trap.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var trap = _get_trap()
	trap.global_position = my_saved_data.position
	
	if(my_saved_data is TrapSavedData):
		var my_data = my_saved_data as TrapSavedData
		trap.consumed = my_data.consumed
		
		if(my_data.consumed):
			trap.go_straight_to_consumed_state()
		
