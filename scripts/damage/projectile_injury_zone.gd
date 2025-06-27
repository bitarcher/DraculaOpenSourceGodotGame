class_name ProjectileInjuryZone
extends Area2D

@export var damage_factor: float = 0.1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# The projectile itself should not be damaged by its own zone
	if body == get_parent():
		return

	var damage_receiver: DamageReceiverComponent = body.find_child("DamageReceiverComponent", true, false)
	if not damage_receiver:
		return

	var projectile_parent = get_parent()
	if not projectile_parent is AProjectile:
		push_error("ProjectileInjuryZone must be a child of a node inheriting from AProjectile.")
		return
		
	var rigid_body = projectile_parent.get_launchable_rigid_body_2D()
	if not rigid_body:
		push_error("Could not find the RigidBody2D for the projectile.")
		return

	var damage_strength = rigid_body.linear_velocity.length() * damage_factor

	if damage_strength >= 6.0:
		damage_receiver.take_damage(damage_strength)
