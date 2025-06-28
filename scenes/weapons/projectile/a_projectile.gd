extends Node2D
class_name AProjectile
	
func get_launchable_rigid_body_2D() -> RigidBody2D:
	push_error("get_launchable_rigid_body_2D method must be overriden")
	return null

func _get_injury_strength(speed: float) -> float:
	return speed * 0.3

func _get_projectile_speed() -> float:
	push_error("_get_projectile_speed not implemented for " + self.name + " : " + self.get_class())
	return 3

	
func get_injury_strength() -> float:
	return _get_injury_strength(_get_projectile_speed())
	
