extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("escape") and visible:
		GameManagerSingleton.resume_game()
		


func _on_new_game_button_pressed() -> void:
	GameManagerSingleton.new_game()
	
func _on_resume_game_button_pressed() -> void:
	GameManagerSingleton.resume_game()


func _on_highscore_game_button_pressed() -> void:
	GameManagerSingleton.show_highscore()
