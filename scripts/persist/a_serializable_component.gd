class_name ASerializableComponent
extends Node

func _ready() -> void:
	add_to_group("Serializable")

func on_save_game(saved_data: Array[SavedData]):
	push_error("Method on_save_game is not implemented in child class.")
	assert(false, "Method on_save_game is not implemented in child class.")
	
func on_before_load_game():
	push_error("Method on_before_load_game is not implemented in child class.")
	assert(false, "Method on_before_load_game is not implemented in child class.")
	
func on_load_game(saved_data: SavedData):
	push_error("Method on_load_game is not implemented in child class.")
	assert(false, "Method on_load_game is not implemented in child class.")
