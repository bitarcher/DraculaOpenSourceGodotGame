class_name AProjectileWeapon
extends AWeapon

@onready var representation: Node2D = %Representation

const rotation_radian_angle: float = 0.1

# ---
func _ready() -> void:
	# Check if the parent is the player
	var parent = get_parent()
	if parent is PlayerPlatformer:
		# Connect to the player's direction changed signal
		parent.direction_changed.connect(_on_player_direction_changed)
		
func _on_player_direction_changed(_emitter: PlayerPlatformer, old_direction: int, new_direction: int) -> void:
	
	if new_direction < 0 and scale.x == 1:
		rotation_degrees = 25
		scale = Vector2(-1, 1)
	elif new_direction > 0 and scale.x == -1:
		rotation_degrees = -25
		scale = Vector2(1, 1)
	# If new_direction is 0, do nothing to keep the last orientation.

# ---
func _process(delta: float) -> void:
	pass

# ---
func get_projectile_scene() -> PackedScene:
	var result = load("res://scenes/weapons/projectile/stone_projectile.tscn")
	return result
	
enum EnumProjectileRange {
	SHORT,
	LONG
}

func get_projectile_speed(projectile_range: EnumProjectileRange) -> float:
	if projectile_range == EnumProjectileRange.SHORT:
		return 300.0
	else:
		return 500.0
		
func get_next_projectile_available_duration_in_milliseconds(projectile_range: EnumProjectileRange) -> float:
	if projectile_range == EnumProjectileRange.SHORT:
		return 300.0
	else:
		return 600.0
		
var next_projectile_available_ticks_in_ms = 0

# This is the virtual method for weapon activation.
# Subclasses can override this to add activation animations or delays.
# By default, it completes immediately.
func _activate_weapon() -> void:
	pass

func throw_projectile(projectile_range: EnumProjectileRange) -> void:
	
	var now = Time.get_ticks_msec()
	
	if (now < next_projectile_available_ticks_in_ms):
		print("projectile not available yet")
		return
	
	# Await the activation animation/delay before proceeding
	await _activate_weapon()
	
	next_projectile_available_ticks_in_ms = now + get_next_projectile_available_duration_in_milliseconds(projectile_range)
	
	var projectile_speed = get_projectile_speed(projectile_range)
	var projectile_scene = get_projectile_scene()
	assert(projectile_scene != null, "La scène du projectile ne doit pas être nulle !")
	
	var projectile: AProjectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	# Positionner le projectile à l'endroit où la représentation de l'arme est.
	projectile.global_position = representation.global_position
	
	# Obtenir le RigidBody2D du projectile
	var rigid_body: RigidBody2D = projectile.get_launchable_rigid_body_2D()
	
	# --- Propulser le RigidBody2D ---
	if rigid_body != null:
		# Calculer la direction de propulsion.
		# 'transform.x' est le vecteur "vers la droite" du nœud, selon sa rotation.
		# Multipliez par 'PROJECTILE_SPEED' pour définir la force de propulsion.
		var launch_direction = global_transform.x.normalized() * projectile_speed
		
		# Appliquer l'impulsion au RigidBody2D
		rigid_body.apply_central_impulse(launch_direction)
	else:
		push_error("Le RigidBody2D du projectile est introuvable ou nul.")

	
func attack_short():
	throw_projectile(EnumProjectileRange.SHORT)
	
func attack_long():
	throw_projectile(EnumProjectileRange.LONG)
	
		
func is_min_angle_reached() -> bool:
	return rotation_degrees < -80

func is_max_angle_reached() -> bool:
	return rotation_degrees > 80
# ---
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("attack_turn_angle_positive"):
		if not is_min_angle_reached():
			rotate(-rotation_radian_angle)
	elif Input.is_action_pressed("attack_turn_angle_negative"):
		if not is_max_angle_reached():
			rotate(rotation_radian_angle)
