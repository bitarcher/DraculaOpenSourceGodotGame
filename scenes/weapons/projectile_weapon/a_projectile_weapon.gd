class_name AProjectileWeapon
extends Node2D

@onready var representation: Node2D = %Representation

const rotation_radian_angle: float = 0.1

# ---
func _ready() -> void:
	pass

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

func throw_projectile(projectile_range: EnumProjectileRange) -> void:
	
	var now = Time.get_ticks_msec()
	
	if (now < next_projectile_available_ticks_in_ms):
		print("projectile not available yet")
		return
	
	next_projectile_available_ticks_in_ms = now + get_next_projectile_available_duration_in_milliseconds(projectile_range)
	
	var projectile_speed = get_projectile_speed(projectile_range)
	var projectile_scene = get_projectile_scene()
	assert(projectile_scene != null, "La scène du projectile ne doit pas être nulle !")
	
	var projectile: AProjectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	# Positionner le projectile à l'endroit où l'arme est (ou à la pointe de l'arme)
	# 'global_position' est la position de ce nœud (AProjectileWeapon) dans le monde.
	# Si vous voulez le faire apparaître à la pointe de votre "representation",
	# vous devrez calculer cette position (representation.global_position + offset).
	projectile.global_position = global_position
	
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
	
# ---
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_short"):
		throw_projectile(EnumProjectileRange.SHORT)
	elif event.is_action_pressed("attack_long"):
		throw_projectile(EnumProjectileRange.LONG)
		
# ---
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("attack_turn_angle_positive"):
		rotate(-rotation_radian_angle)
	elif Input.is_action_pressed("attack_turn_angle_negative"):
		rotate(rotation_radian_angle)
