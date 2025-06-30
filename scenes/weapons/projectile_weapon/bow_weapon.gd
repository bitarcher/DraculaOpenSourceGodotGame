class_name BowWeapon
extends AProjectileWeapon

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@export var arrow_type: ArrowProjectile.ArrowType = ArrowProjectile.ArrowType.NORMAL
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Representation/Sprite2D
@onready var bow_loading_audio_stream_player_2d: AudioStreamPlayer2D = %BowLoadingAudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func _edit_projectile_before_adding_to_scene(projectile: AProjectile):
	var arrow: ArrowProjectile = projectile as ArrowProjectile
	arrow.arrow_type = arrow_type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
func _activate_weapon() -> void:
	bow_loading_audio_stream_player_2d.play()
	sprite_2d.visible = false
	animated_sprite_2d.play("launch")
	animated_sprite_2d.animation_finished
	audio_stream_player.play()
	

func get_weapon_name() -> String:
	return CurrentlyUsedItems.BOW
	
func get_projectile_scene() -> PackedScene:
	var result = load("res://scenes/weapons/projectile/arrow_projectile.tscn")
	return result
	
func get_projectile_speed(projectile_range: EnumProjectileRange) -> float:
	if projectile_range == EnumProjectileRange.SHORT:
		return 500.0
	else:
		return 700.0
