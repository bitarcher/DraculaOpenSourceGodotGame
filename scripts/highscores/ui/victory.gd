class_name Victory
extends Node2D

signal victory_displayed()


func _on_audio_stream_player_finished() -> void:
	victory_displayed.emit()
