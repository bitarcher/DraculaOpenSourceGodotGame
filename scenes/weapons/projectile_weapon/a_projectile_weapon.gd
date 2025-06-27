class_name AProjectileWeapon
extends Node2D

@onready var representation: Node2D = %Representation

const rotation_radian_angle: float = 0.1
const PROJECTILE_SPEED: float = 500.0 # Vitesse de propulsion du projectile

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

# ---
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_short"):
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
			var launch_direction = global_transform.x.normalized() * PROJECTILE_SPEED
			
			# Appliquer l'impulsion au RigidBody2D
			rigid_body.apply_central_impulse(launch_direction)
		else:
			push_error("Le RigidBody2D du projectile est introuvable ou nul.")
		
# ---
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("attack_turn_angle_positive"):
		rotate(-rotation_radian_angle)
	elif Input.is_action_pressed("attack_turn_angle_negative"):
		rotate(rotation_radian_angle)
