class_name LevelConst
extends Node2D

signal game_over_done()
signal victory_against_dracula_displayed()

signal player_name_entered(player_name: String)

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func show_game_over():
	var game_over_scene: PackedScene = preload("res://scenes/highscores/ui/game_over.tscn")
	
	var game_over_entity: GameOver = game_over_scene.instantiate()
	
	#Définir la position
	game_over_entity.position = Vector2(584, 367)
	
	# Définir l'échelle (scale)
	game_over_entity.scale = Vector2(2.0, 2.0)
	
	game_over_entity.game_over_finished_to_display.connect(_on_game_over_finished_to_display)
	
	# Ajouter l'entité au canvas_layer
	canvas_layer.add_child(game_over_entity)

func show_enter_player_name():
	var enter_player_name_scene: PackedScene = preload("res://scenes/highscores/ui/enter_player_name.tscn")
	
	var enter_player_name: EnterPlayerName = enter_player_name_scene.instantiate()
	
	#Définir la position
	enter_player_name.position = Vector2(552, 472)
	
	
	enter_player_name.player_entered.connect(_on_player_name_entered)
	
	# Ajouter l'entité au canvas_layer
	canvas_layer.add_child(enter_player_name)
	
func show_victory_against_dracula():
	var victory_scene: PackedScene = preload("res://scenes/highscores/ui/victory.tscn")
	
	var victory_entity: Victory = victory_scene.instantiate()
	
	#Définir la position
	victory_entity.position = Vector2(584, 328)
	
	# Définir l'échelle (scale)
	victory_entity.scale = Vector2(3.0, 3.0)
	victory_entity.z_index = -1
	
	victory_entity.victory_displayed.connect(_on_victory_displayed)
	
	# Ajouter l'entité au canvas_layer
	canvas_layer.add_child(victory_entity)


func _on_victory_displayed():
	$CanvasLayer/LevelUi.queue_free()
	victory_against_dracula_displayed.emit()
	
func _on_game_over_finished_to_display():
	game_over_done.emit()

func _on_player_name_entered(player_name: String):
	player_name_entered.emit(player_name)
		
