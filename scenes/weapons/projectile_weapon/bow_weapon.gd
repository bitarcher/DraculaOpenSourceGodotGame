class_name BowWeapon
extends AProjectileWeapon

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@export var arrow_type: ArrowProjectile.ArrowType = ArrowProjectile.ArrowType.NORMAL


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
	audio_stream_player.play()
	animation_player.play("activate")
	await animation_player.animation_finished

func get_weapon_name() -> String:
	return CurrentlyUsedItems.BOW
	
func get_projectile_scene() -> PackedScene:
	var result = load("res://scenes/weapons/projectile/arrow_projectile.tscn")
	return result
