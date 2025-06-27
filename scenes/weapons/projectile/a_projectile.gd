extends Node2D
class_name AProjectile
	
func get_launchable_rigid_body_2D() -> RigidBody2D:
	push_error("get_launchable_rigid_body_2D method must be overriden")
	return null

func _get_injury_strength(speed: float):
	return speed * 0.3
	
func _on_projectile_injury_zone_entered(body: Node2D, speed: float) -> void:
	
	
	var injury_strength = _get_injury_strength(speed)
	
	print(body.get_class() + " entered injury zone of projectile " + self.get_class() + ", injury strength is " + str(injury_strength))
	
	if ToolsSingleton.is_body_relative_to_player(body):
		GameManagerSingleton.injured(InjuryZone.EnumInjuryZoneType.PROJECTILE, injury_strength)
		return
	
	var damage_receiver_component: DamageReceiverComponent = ToolsSingleton.get_damage_receiver_component_relative_to_body_if_exists(body)
	
	if(damage_receiver_component != null):
		damage_receiver_component.take_damage(InjuryZone.EnumInjuryZoneType.PROJECTILE, injury_strength)
	
