extends Node2D
class_name AWeapon


func attack_short():
	push_warning("attack_short not implemented for " + ToolsSingleton.get_node_ariane_thread(self))
	return
	
func attack_long():
	push_warning("attack_long not implemented for " + ToolsSingleton.get_node_ariane_thread(self))
	return
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_short"):
		attack_short()
	elif event.is_action_pressed("attack_long"):
		attack_long()
