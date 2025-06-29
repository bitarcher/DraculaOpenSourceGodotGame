extends Node2D

@onready var jingle_bell_audio_stream_player_2d: AudioStreamPlayer2D = %JingleBellAudioStreamPlayer2D
@onready var yodel_audio_stream_player_2d: AudioStreamPlayer2D = %YodelAudioStreamPlayer2D



func _on_jingle_bell_audio_stream_player_2d_finished() -> void:
	await get_tree().create_timer(20.0).timeout
	yodel_audio_stream_player_2d.play()


func _on_yodel_audio_stream_player_2d_finished() -> void:
	await get_tree().create_timer(30.0).timeout
	jingle_bell_audio_stream_player_2d.play()
