extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Panel/GridContainer/MarginContainer2/CoinsLabel.text = str(GameManagerSingleton.num_of_coins)
	$Panel/GridContainer/MarginContainer4/LivesLabel.text = str(GameManagerSingleton.num_of_lives)
