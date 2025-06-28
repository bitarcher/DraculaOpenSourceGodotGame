class_name ProjectileInjuryZone
extends Area2D

@export var damage_factor: float = 0.1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	
	print("projectile injury zone body entered " + body.name + " : " + body.get_class() )
	

	var damage_receiver: DamageReceiverComponent = ToolsSingleton.get_damage_receiver_component_relative_to_body_if_exists(body)

	if(damage_receiver != null):
		print("damage receiver found")
	else:
		print("damage receiver not found")

	var projectile_parent = get_parent()
	if not projectile_parent is AProjectile:
		push_error("ProjectileInjuryZone must be a child of a node inheriting from AProjectile.")
		return
		
	
	print("projectile parent found")
		
	var rigid_body = projectile_parent.get_launchable_rigid_body_2D()
	if not rigid_body:
		push_error("Could not find the RigidBody2D for the projectile.")
		return
		
	print("rigid body found")	

	var damage_strength = rigid_body.linear_velocity.length() * damage_factor

	if damage_strength >= 6.0:
		damage_receiver.take_damage(InjuryZone.EnumInjuryZoneType.PROJECTILE, damage_strength)
