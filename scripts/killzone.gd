extends Area2D



@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	print("You died")
	timer.start()


func _on_timer_timeout() -> void:
	var game_manager : GameManager = find_game_manager()
	game_manager.killed()
	
# Fonction utilitaire pour trouver un nœud par son type
func find_game_manager():
	var tree = get_tree()
	var root = tree.root
	
	var result = get_first_node_of_type("GameManager", root)
		
	return result


# Fonction utilitaire pour trouver tous les nœuds d'un type donné
func get_first_node_of_type(target_type, parent_node = self):
	
	var parent_node_class = parent_node.get_class()
	if(parent_node_class == target_type):
		return parent_node
	
	for child in parent_node.get_children():		
		var better_result_deeper = get_first_node_of_type(target_type, child)
		
		if(better_result_deeper != null):
			return better_result_deeper
		
	return null
