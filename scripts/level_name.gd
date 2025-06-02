extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Panel/Label.text = "Level " + str(GameManagerSingleton.current_level)
