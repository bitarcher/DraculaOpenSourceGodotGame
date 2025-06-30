class_name ArrowProjectile
extends AProjectile

@onready var rigid_body_2d: RigidBody2D = %RigidBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var projectile_injury_zone: ProjectileInjuryZone = %ProjectileInjuryZone
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

@export var high_speed_threshold: float = 100.0 # Adjust this value as needed

@export var arrow_type: ArrowType = ArrowType.NORMAL

@export_category("Textures")
@export var normal_arrow_texture: AtlasTexture
@export var poisoned_arrow_texture: AtlasTexture
@onready var sprite: Sprite2D = %Sprite2D

var _arrow_texture_set: bool = false
var is_stuck: bool = false # Variable d'état pour savoir si la flèche est plantée

func _ready() -> void:
	# On connecte le signal du RigidBody2D à notre fonction de logique de collision
	rigid_body_2d.body_entered.connect(_on_rigid_body_2d_body_entered)

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	# Si la flèche est déjà plantée ou si le corps n'est pas un corps physique, on ignore.
	if is_stuck or not (body is PhysicsBody2D) or body is PlayerPlatformer:
		return

	is_stuck = true
	
	print("arrow will stuck to " + ToolsSingleton.get_node_ariane_thread(body))

	# Court délai pour simuler la pénétration de la flèche
	await get_tree().create_timer(0.003).timeout

	# Sauvegarde de la transformation globale avant de changer de parent
	var original_transform = global_transform

	var global_position = rigid_body_2d.global_position
	var global_rotation = rigid_body_2d.global_rotation
	# Reparentage de la flèche
	remove_child(rigid_body_2d)
	body.add_child(rigid_body_2d)
	
	rigid_body_2d.global_position = global_position
	rigid_body_2d.global_rotation = global_rotation

	# Restauration de la transformation pour éviter un saut visuel
	global_transform = original_transform
	
	# Arrêt de la physique
	rigid_body_2d.freeze = true
	collision_shape_2d.disabled = true
	
	# On peut aussi désactiver la zone de blessure
	if is_instance_valid(projectile_injury_zone):
		projectile_injury_zone.queue_free()

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
	# Si la flèche est plantée, on ne fait plus aucune mise à jour physique
	if is_stuck:
		return
		
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
		audio_stream_player_2d.play()
		
func _on_projectile_injury_zone_projectile_injury_zone_hurt_someone(body: Node2D) -> void:
	if is_instance_valid(projectile_injury_zone):
		projectile_injury_zone.queue_free()
