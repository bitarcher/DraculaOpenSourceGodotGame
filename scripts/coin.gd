extends Area2D	

func _on_body_entered(body: Node2D) -> void:
	visible = false
	$AudioStreamPlayer.play()
	GameManagerSingleton.coin_fetched()
	
func _on_audio_stream_player_finished() -> void:
	queue_free()
