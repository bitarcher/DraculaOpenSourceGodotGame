extends Node

@export var num_of_lives: int
@export var num_of_injuries_allowed: int
@export var num_of_coins: int 

@export var level_start_ticks: int
var num_of_coins_before_killed : int = 0


var immunity: bool = false


signal player_injured() 
signal player_killed() 

var immunity_lost_timer: Timer
var killed_timer: Timer

const NUM_OF_LEVELS: int = 6

var _levels_resources: Array[Resource] = []
var _menu_resource: Resource

func _init_level_resources():
	_levels_resources = [
		preload("res://scenes/p_level_0.tscn"),
		preload("res://scenes/p_level_1.tscn"),
		preload("res://scenes/p_level_2.tscn"),
		preload("res://scenes/p_level_3.tscn"),
		preload("res://scenes/p_level_4.tscn"),
		preload("res://scenes/p_level_5.tscn")
	]
	print(str(_levels_resources.size()) + " levels loaded")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_menu_resource = preload("res://scenes/menu.tscn")
	level_start_ticks = Time.get_ticks_msec()
	_init_level_resources()
	reset_counters()
	immunity_lost_timer = Timer.new()
	add_child(immunity_lost_timer)
	
	immunity_lost_timer.wait_time = 2.0
	immunity_lost_timer.connect("timeout", _on_immunity_lost_timer_timeout)
	
	killed_timer = Timer.new()
	add_child(killed_timer)
	killed_timer.wait_time = 2.0
	killed_timer.ignore_time_scale = true
	killed_timer.connect("timeout", _on_killed_timer_timeout)

const INITIAL_NUM_OF_LIVES = 5
const INITIAL_NUM_OF_INJURIES_ALLOWED = 3

var current_level = 1
@onready var level_1 = preload("res://scripts/p_level_1.gd")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _goto_level():
	level_start_ticks = Time.get_ticks_msec()
	if(current_level >= NUM_OF_LEVELS):
		print("END OF GAME : bravo")
	else:
		print("NEW LEVEL IS " + str(current_level))
		var scene_res = _levels_resources[current_level]
		get_tree().change_scene_to_packed(scene_res)
		
func next_level():
	num_of_coins_before_killed = num_of_coins
	if(num_of_lives < 4):
		num_of_lives += 2
	else:
		num_of_lives += 1
	current_level +=1 
	
	_goto_level()
	
	print("next level")
	
func load_level(level: int):
	current_level = level
	_goto_level()
	
func reset_counters():
	num_of_coins_before_killed = 0
	num_of_coins = 0
	num_of_lives = INITIAL_NUM_OF_LIVES
	num_of_injuries_allowed = INITIAL_NUM_OF_INJURIES_ALLOWED
	
func resume_game():
	#_goto_level()
	
	SaverLoaderSingleton.load_game()
	
func show_menu():
	SaverLoaderSingleton.save_game()
	get_tree().change_scene_to_packed(_menu_resource)

func coin_fetched():
	num_of_coins += 1	

func live_fetched():
	num_of_lives += 1
	
func new_game():
	print("NEW GAME REQUESTED")
	current_level = 1
	_goto_level()

func injured():
	if(immunity):
		return
		
	num_of_injuries_allowed -= 1
	
	if(num_of_injuries_allowed <= 0):
		killed()
	else:
		print("start of immunity")
		immunity = true
		immunity_lost_timer.start()
		
		emit_signal("player_injured")
		
func killed():
	Engine.time_scale = 0.3
	print("killed using game manager")
	num_of_coins = num_of_coins_before_killed
	num_of_lives -= 1
	num_of_injuries_allowed = INITIAL_NUM_OF_INJURIES_ALLOWED
	
	emit_signal("player_killed")
	
	killed_timer.start()
	
	
	
func game_over():
	print("game over")
	print("total coins:" + str(num_of_coins))
	#TODO


func _on_immunity_lost_timer_timeout() -> void:
	print("end of immunity")
	immunity = false
	immunity_lost_timer.stop()

func _on_killed_timer_timeout() -> void:
	Engine.time_scale = 1.0
	killed_timer.stop()
	
	if(num_of_lives <= 0):
		game_over()
	else:
		get_tree().reload_current_scene()
