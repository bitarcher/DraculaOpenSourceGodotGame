extends Node2D

@onready var wind_audio_stream_player: AudioStreamPlayer = %WindAudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_wind_audio_stream_player_finished() -> void:
	wind_audio_stream_player.play()
