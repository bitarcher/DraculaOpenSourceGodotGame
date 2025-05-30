extends Node

@export var num_of_lives: int
var num_of_injuries_allowed 

var immunity: bool = false

signal player_injured() 

var immunity_lost_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_counters()
	immunity_lost_timer = Timer.new()
	add_child(immunity_lost_timer)
	immunity_lost_timer.wait_time = 2.0
	immunity_lost_timer.connect("timeout", _on_immunity_lost_timer_timeout)

const INITIAL_NUM_OF_LIVES = 5
const INITIAL_NUM_OF_INJURIES_ALLOWED = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset_counters():
	num_of_lives = INITIAL_NUM_OF_LIVES
	num_of_injuries_allowed = INITIAL_NUM_OF_INJURIES_ALLOWED
	
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
	print("killed using game manager")
	num_of_lives -= 1
	num_of_injuries_allowed = INITIAL_NUM_OF_INJURIES_ALLOWED
	
	if(num_of_lives <= 0):
		game_over()
	else:
		get_tree().reload_current_scene()
	
func game_over():
	print("game over")
	#TODO


func _on_immunity_lost_timer_timeout() -> void:
	print("end of immunity")
	immunity = false
	immunity_lost_timer.stop()
