class_name Victory
extends Node2D

signal victory_displayed()

func _on_timer_timeout() -> void:
	$Timer.stop()
	victory_displayed.emit()
