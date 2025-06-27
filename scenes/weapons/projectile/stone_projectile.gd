class_name StoneProjectile
extends AProjectile

@onready var rigid_body_2d: RigidBody2D = %RigidBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = %AudioStreamPlayer2D2

@export var high_speed_threshold: float = 100.0 # Adjust this value as needed

var _previous_linear_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	_previous_linear_velocity = rigid_body_2d.linear_velocity

func get_launchable_rigid_body_2D() -> RigidBody2D:
	return rigid_body_2d

func _on_injury_area_2d_body_entered(body: Node2D) -> void:
	if _previous_linear_velocity.length() > high_speed_threshold:
		if (randi() % 2) == 0: 
			audio_stream_player_2d.play()
		else:
			audio_stream_player_2d_2.play()
		
		_on_projectile_injury_zone_entered(body, _previous_linear_velocity.length())
