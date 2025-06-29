extends Node2D

@onready var horror_audio_stream_player_2d: AudioStreamPlayer2D = %HorrorAudioStreamPlayer2D




func _on_horror_audio_stream_player_2d_finished() -> void:
	horror_audio_stream_player_2d.play()
