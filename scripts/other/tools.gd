class_name Tools
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_nodes_in_group_from_node(node: Node, group_name: String) -> Array[Node]:
	var result: Array[Node] = []
	var children = node.find_children("*", "", true, false)  # Récursif
	
	for child in children:
		if child.is_in_group(group_name):
			result.append(child)
	
	return result
	
	
func dump_scene_tree(node: Node = get_tree().root, indent_level: int = 0):
	var indent = ""
	
	for i in range(0, indent_level):
		indent += "	 "
	
	var node_name = node.name
	var node_type = node.get_class()
	var node_path = node.get_path()

	print(indent + "- " + node_name + " (" + node_type + ") [" + str(node_path) + "]")

	# Itérer sur les enfants du nœud et appeler récursivement la fonction
	for child in node.get_children():
		dump_scene_tree(child, indent_level + 1)
