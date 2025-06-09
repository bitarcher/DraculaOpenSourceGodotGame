class_name HighScoreItem
extends Resource

@export var num_of_coins: int
@export var max_level:int
@export var remaining_lives: int
@export var player_name: String

func _init(p_name: String = "", p_num_of_coins: int = 0, p_max_level: int = 0, p_remaining_lives: int = 0):
	player_name = p_name
	num_of_coins = p_num_of_coins
	max_level = p_max_level
	remaining_lives = p_remaining_lives
