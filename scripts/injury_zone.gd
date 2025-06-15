extends Area2D

@export var injury_strength: float = 34 


func _on_body_entered(_body: Node2D) -> void:
	GameManagerSingleton.injured(injury_strength)
