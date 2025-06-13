class_name BlueDiamondSerializableComponent
extends ASerializableComponent

func _get_blue_diamond() -> BlueDiamond:
	return get_parent()
	
func on_save_game(saved_datas):
	var blue_diamond = _get_blue_diamond()
	
	if not blue_diamond.visible:
		return
		
	var my_data = SavedData.new()
	my_data.scene_path = "res://scenes/blue_diamond.tscn"
	my_data.position = blue_diamond.global_position
	
	saved_datas.append(my_data)
	
func on_before_load_game():
	var blue_diamond = _get_blue_diamond()
	blue_diamond.get_parent().remove_child(blue_diamond)
	blue_diamond.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var blue_diamond = _get_blue_diamond()
	blue_diamond.global_position = my_saved_data.position
	
		
		
