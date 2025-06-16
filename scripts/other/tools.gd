class_name Tools
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
		
		
# Retrieves all child nodes (and their descendants) that match a given class name.
#
# @param node: The starting node from which to begin the search.
# @param search_class_name: The name of the class to search for (e.g., "CharacterBody2D", "Sprite2D", "MyCustomEnemy").
# @return An Array of Node objects matching the specified class name.
func get_nodes_from_class(node: Node, search_class_name: String) -> Array[Node]:
	var found_nodes: Array[Node] = []

	# Check the current node first
	if node.get_class() == search_class_name:
		found_nodes.append(node)

	# Recursively search through children
	for child in node.get_children():
		found_nodes.append_array(get_nodes_from_class(child, search_class_name))

	return found_nodes

func get_node_from_class(node: Node, search_class_name: String) -> Node:
	var nodes = get_nodes_from_class(node, search_class_name)
	if(len(nodes) > 0):
		return nodes[0]
	else:
		return null
		
func get_player_platformer() -> PlayerPlatformer:
	var root = get_tree().current_scene
	var nodes = get_nodes_in_group_from_node(root, "Player")
	
	if(len(nodes) > 0):
		var node = nodes[0]
		if ( node is PlayerPlatformer):
			return node as PlayerPlatformer
		else:
			print("Player is not PlayerPlatformer")
			return null
	else:
		print("no PlayerPlatformer found")
		return null
