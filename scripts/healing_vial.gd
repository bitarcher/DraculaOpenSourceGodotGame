extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	visible = false
	$AudioStreamPlayer.play()
	GameManagerSingleton.live_fetched()
	
func _on_audio_stream_player_finished() -> void:
	queue_free()
