class_name SlingshotWeapon
extends AProjectileWeapon

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
func _activate_weapon() -> void:
	audio_stream_player.play()
	animation_player.play("activate")
	await animation_player.animation_finished
