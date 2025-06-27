class_name GameManager
extends Node

@export var num_of_lives: int
@export var num_of_coins: int 
@export var num_of_diamonds: int = 50

@export var level_start_ticks: int
var num_of_coins_before_killed : int = 0
var num_of_blue_diamonds_before_killed: int = 0
var inventory_items_before_killed: Array[Item] = []
var currently_used_items_saved_data_before_killed: Array[CurrentlyUsedItemSavedData] = []

var immunity: bool = false

@export var health: float = INITIAL_HEALTH

@export var inventory: Inventory = Inventory.new()

@export var currently_used_items: CurrentlyUsedItems = CurrentlyUsedItems.new()
 
signal health_changed(new_health: float)
signal player_injured(strength: float) 
signal player_killed() 
signal player_name_requested_for_saving_new_highscore(context: SavingPlayerContext)

var immunity_lost_timer: Timer
var killed_timer: Timer

var _levels_resources: Array[Resource] = []
var _menu_resource: Resource
var _highscore_resource: Resource
var _credits_resource: Resource

const NUM_OF_LEVELS: int = 21
const INITIAL_HEALTH: float = 100.0

func _init_level_resources():
	_levels_resources = [
		preload("res://scenes/p_level_0.tscn"),
		preload("res://scenes/p_level_1.tscn"),
		preload("res://scenes/p_level_2.tscn"),
		preload("res://scenes/p_level_3.tscn"),
		preload("res://scenes/p_level_4.tscn"),
		preload("res://scenes/p_level_5.tscn"),
		preload("res://scenes/p_level_6.tscn"),
		preload("res://scenes/p_level_7.tscn"),
		preload("res://scenes/p_level_8.tscn"),
		preload("res://scenes/p_level_9.tscn"),
		preload("res://scenes/p_level_10.tscn"),
		preload("res://scenes/p_level_11.tscn"),
		preload("res://scenes/p_level_12.tscn"),
		preload("res://scenes/p_level_13.tscn"),
		preload("res://scenes/p_level_14.tscn"),
		preload("res://scenes/p_level_15.tscn"),
		preload("res://scenes/p_level_16.tscn"),
		preload("res://scenes/p_level_17.tscn"),
		preload("res://scenes/p_level_18.tscn"),
		preload("res://scenes/p_level_19.tscn"),
		preload("res://scenes/p_level_20.tscn"),
	]
	print(str(_levels_resources.size()) + " levels loaded")

func set_health(health: float) -> void:
	self.health = health
	health_changed.emit(health)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_menu_resource = preload("res://scenes/menu.tscn")
	_highscore_resource = preload("res://scenes/highscores.tscn")
	_credits_resource = preload("res://scenes/credits.tscn")
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
	
func _get_defense_factor(injury_zone_type: InjuryZone.EnumInjuryZoneType):
	return currently_used_items.get_defense_factor(injury_zone_type)

const INITIAL_NUM_OF_LIVES = 5

var current_level = 1
@onready var level_1 = preload("res://scripts/p_level_1.gd")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _goto_level():
	level_start_ticks = Time.get_ticks_msec()
	if(current_level >= NUM_OF_LEVELS):
		end_of_game()
	else:
		print("NEW LEVEL IS " + str(current_level))
		var scene_res = _levels_resources[current_level]
		get_tree().change_scene_to_packed(scene_res)
		
func end_of_game():
	print("END OF GAME : Victory")
			
	var prepare_highscore: PrepareHighscore = PrepareHighscore.new(self)
	
	prepare_highscore.level_const.victory_against_dracula_displayed.connect(_on_level_const_game_over_done.bind(prepare_highscore.level_const, prepare_highscore.context))
	prepare_highscore.level_const.show_victory_against_dracula()
	
func _on_victory_against_dracula_displayed(level_const: LevelConst, maybe_saving_player_context: SavingPlayerContext):
	print(_on_level_const_game_over_done)
	
	if(maybe_saving_player_context == null):
		reset_counters()
		return
	
	level_const.player_name_entered.connect(_on_level_const_player_name_entered.bind(level_const, maybe_saving_player_context))
	level_const.show_enter_player_name()

		
func next_level():
	health = INITIAL_HEALTH
	num_of_coins_before_killed = num_of_coins
	num_of_blue_diamonds_before_killed = num_of_diamonds
	inventory_items_before_killed = inventory.get_items().duplicate(true)
	
	currently_used_items_saved_data_before_killed = []
	
	for currently_used_item in currently_used_items.get_cu_items():
		var currently_used_item_saved_data = CurrentlyUsedItemSavedData.new()
		currently_used_item_saved_data.from_currently_used_item(currently_used_item)
		currently_used_items_saved_data_before_killed.append(currently_used_item_saved_data)
	
	if(num_of_lives < 2):
		num_of_lives += 1
	
	current_level +=1 
	
	_goto_level()
	
	print("next level")
	
func load_level(level: int):
	current_level = level
	_goto_level()
	
func reset_counters():
	health = INITIAL_HEALTH
	num_of_coins_before_killed = 0
	num_of_blue_diamonds_before_killed = 0
	inventory_items_before_killed = []
	currently_used_items_saved_data_before_killed = []
	num_of_diamonds = 0
	num_of_coins = 0
	num_of_lives = INITIAL_NUM_OF_LIVES
	
func resume_game():
	#_goto_level()
	
	SaverLoaderSingleton.load_game()
	
func show_menu(save_game_also=true):
	if(save_game_also):
		SaverLoaderSingleton.save_game()
	get_tree().change_scene_to_packed(_menu_resource)

func coin_fetched():
	num_of_coins += 1	

func live_fetched():
	num_of_lives += 1
	
func blue_diamond_fetched():
	num_of_diamonds += 10
	
func new_game():
	print("NEW GAME REQUESTED")
	reset_counters()
	current_level = 1
	_goto_level()

func injured(injury_zone_type: InjuryZone.EnumInjuryZoneType, strength: float):
	
	if(immunity):
		return
	
	var level = strength / _get_defense_factor(injury_zone_type)
	
	if level < 0.1:
		return
	
	health -= level
	
	if (health  <= 0.0):
		health = 0.0
		
		player_injured.emit(strength)
		health_changed.emit(health)
		killed()
	else:
		print("start of immunity")
		immunity = true
		immunity_lost_timer.start()
		player_injured.emit(strength)
		health_changed.emit(health)
		
func killed():
	Engine.time_scale = 0.3
	print("killed using game manager")
	num_of_coins = num_of_coins_before_killed
	num_of_diamonds = num_of_blue_diamonds_before_killed
	inventory.set_items(inventory_items_before_killed.duplicate(true))
	currently_used_items.clear()
	
	for currently_used_item_saved_data in currently_used_items_saved_data_before_killed:
		var currently_used_item  = currently_used_item_saved_data.to_currently_used_item()
		currently_used_items.add_cu_item(currently_used_item)
	
	
	num_of_lives -= 1
	
	emit_signal("player_killed")
	
	killed_timer.start()
	
class PrepareHighscore:
	var highscore_items: HighScoreItems
	var player_high_score_item: HighScoreItem
	
	var can_add: bool
	
	var context: SavingPlayerContext
	
	var level_const: LevelConst
		
	func _init(gm: GameManager):
		print("total coins:" + str(gm.num_of_coins))
		highscore_items = HighScoreItems.load()
		
		player_high_score_item = HighScoreItem.new("John Woo", 
			gm.num_of_coins, gm.current_level, gm.num_of_lives)
	
		can_add = highscore_items.add_highscore_item_if_possible(player_high_score_item)
	
		if(can_add):
			context = SavingPlayerContext.new()
			context.highscore_items = highscore_items
			context.player_highscore_item = player_high_score_item
			gm.player_name_requested_for_saving_new_highscore.emit(context)
			
		level_const = gm.get_tree().get_first_node_in_group("LevelConst")
		
func game_over():
	print("game over")
	
	var prepare_highscore: PrepareHighscore = PrepareHighscore.new(self)
	
	prepare_highscore.level_const.game_over_done.connect(_on_level_const_game_over_done.bind(prepare_highscore.level_const, prepare_highscore.context))
	prepare_highscore.level_const.show_game_over()

func _on_level_const_game_over_done(level_const: LevelConst, maybe_saving_playe_context: SavingPlayerContext):
	print(_on_level_const_game_over_done)
	
	if(maybe_saving_playe_context == null):
		reset_counters()
		return
	
	level_const.player_name_entered.connect(_on_level_const_player_name_entered.bind(level_const, maybe_saving_playe_context))
	level_const.show_enter_player_name()

func _on_level_const_player_name_entered(player_name: String,_level_const: LevelConst, savingPlayerContext: SavingPlayerContext):
	print("_on_level_const_player_name_entered")
	savingPlayerContext.player_highscore_item.player_name = player_name
	savingPlayerContext.highscore_items.save()
	reset_counters()
	show_highscore()


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
		health = INITIAL_HEALTH

func show_highscore():
	get_tree().change_scene_to_packed(_highscore_resource)
	
func show_credits():
	get_tree().change_scene_to_packed(_credits_resource)
