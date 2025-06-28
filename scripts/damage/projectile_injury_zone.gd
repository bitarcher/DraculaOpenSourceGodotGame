class_name ProjectileInjuryZone
extends Area2D

@export var damage_factor: float = 0.1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	
	print("projectile injury zone body entered " + body.name + " : " + body.get_class() )
	
	var projectile = ToolsSingleton.get_first_ancestor_of_group(self, "Projectile")
	if not projectile is AProjectile:
		push_error("ProjectileInjuryZone must be a child of a node inheriting from AProjectile.")
		return
	
	print("projectile found")	
	
	var injury_strength = projectile.get_injury_strength()

	if ToolsSingleton.is_body_relative_to_player(body):
		GameManagerSingleton.injured(InjuryZone.EnumInjuryZoneType.PROJECTILE, injury_strength)
		return
	
	var damage_receiver_component: DamageReceiverComponent = ToolsSingleton.get_damage_receiver_component_relative_to_body_if_exists(body)
	
	if(damage_receiver_component != null):
		print("damage receiver component found")
		ToolsSingleton.print_node_ariane_thread(damage_receiver_component)
		print("body is")
		ToolsSingleton.print_node_ariane_thread(body)
		damage_receiver_component.take_damage(InjuryZone.EnumInjuryZoneType.PROJECTILE, injury_strength)
	else:
		print("damage receiver not found")
	
