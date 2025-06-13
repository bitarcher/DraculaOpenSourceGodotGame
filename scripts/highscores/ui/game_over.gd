extends Node2D
class_name GameOver

signal game_over_finished_to_display()


func _on_timer_timeout() -> void:
	game_over_finished_to_display.emit()
