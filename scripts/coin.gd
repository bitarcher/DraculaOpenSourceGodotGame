class_name Coin
extends Area2D	
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

func _on_body_entered(_body: Node2D) -> void:
	visible = false
	$AudioStreamPlayer.play()
	GameManagerSingleton.coin_fetched()
	collision_shape_2d.queue_free()
	
func _on_audio_stream_player_finished() -> void:
	queue_free()
