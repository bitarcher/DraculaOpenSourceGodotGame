extends Node2D

@onready var high_scores_display: PanelContainer = %HighScoresDisplay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var highscore_items : HighScoreItems = HighScoreItems.load()
	
	high_scores_display.high_score_data = highscore_items
	high_scores_display.refresh_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("escape") and visible:
		GameManagerSingleton.show_menu(false)
