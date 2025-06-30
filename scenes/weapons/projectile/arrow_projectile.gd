class_name ArrowProjectile
extends AProjectile

@onready var rigid_body_2d: RigidBody2D = %RigidBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = %AudioStreamPlayer2D2
@onready var projectile_injury_zone: ProjectileInjuryZone = %ProjectileInjuryZone

@export var high_speed_threshold: float = 100.0 # Adjust this value as needed

@export var arrow_type: ArrowType = ArrowType.NORMAL

@export_category("Textures")
@export var normal_arrow_texture: AtlasTexture
@export var poisoned_arrow_texture: AtlasTexture
@onready var sprite: Sprite2D = %Sprite2D

var _arrow_texture_set: bool = false

func set_arrow_texture():
	if _arrow_texture_set:
		return
	
	#FIXME
	return
	
	_arrow_texture_set = true
	match arrow_type:
		ArrowType.NORMAL:
			sprite.texture = normal_arrow_texture
		ArrowType.POISONED:
			sprite.texture = poisoned_arrow_texture
		_:
			_arrow_texture_set = false
			
	if _arrow_texture_set:
		print("arrow tecture set")
	else:
		push_error("arrow tecture not set")

enum ArrowType {
	NORMAL,
	POISONED
}

func _process(delta: float) -> void:
	set_arrow_texture()
	
var _previous_linear_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	_previous_linear_velocity = rigid_body_2d.linear_velocity

	if rigid_body_2d.linear_velocity.length() > 0.1:
		rigid_body_2d.rotation = rigid_body_2d.linear_velocity.angle() + PI / 2

func get_launchable_rigid_body_2D() -> RigidBody2D:
	return rigid_body_2d

func _get_projectile_speed() -> float:
	return _previous_linear_velocity.length()

func _get_injury_strength(speed: float) -> float:
	
	var extra_factor: float = 1.0
	
	match arrow_type:
		ArrowType.POISONED:
			extra_factor = 1.3
	
	return speed * 0.4 * extra_factor

func _on_projectile_injury_zone_body_entered(body: Node2D) -> void:
	if _get_projectile_speed() > high_speed_threshold:
		if (randi() % 2) == 0: 
			audio_stream_player_2d.play()
		else:
			audio_stream_player_2d_2.play()


func _on_projectile_injury_zone_projectile_injury_zone_hurt_someone(body: Node2D) -> void:
	projectile_injury_zone.queue_free()
