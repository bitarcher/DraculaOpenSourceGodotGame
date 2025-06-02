class_name HealingVialSerializableComponent
extends ASerializableComponent

func _get_healing_vial() -> HealingVial:
	return get_parent()
	
func on_save_game(saved_datas):
	var healing_vial = _get_healing_vial()
	
	if not healing_vial.visible:
		return
		
	var my_data = SlimeEnemySavedData.new()
	my_data.scene_path = "res://scenes/healing_vial.tscn"
	my_data.position = healing_vial.global_position
	
	saved_datas.append(my_data)
	
func on_before_load_game():
	var healing_vial = _get_healing_vial()
	healing_vial.get_parent().remove_child(healing_vial)
	healing_vial.queue_free()

func on_load_game(saved_data):
	var my_saved_data = saved_data as SavedData
	var healing_vial = _get_healing_vial()
	healing_vial.global_position = my_saved_data.position
	
		
		
