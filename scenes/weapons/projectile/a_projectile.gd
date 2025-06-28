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

var launched_ticks_in_ms = null
var _is_projectile_active : bool = true

func is_projectile_active() -> bool:
	return _is_projectile_active

func _process(delta: float) -> void:
	if(launched_ticks_in_ms != null and _get_projectile_speed() < 2 and _is_projectile_active):
		_is_projectile_active = false
		print("end of activity for projectile :")
		ToolsSingleton.print_node_ariane_thread(self)
	
	if(launched_ticks_in_ms == null and _get_projectile_speed() > 0):
		launched_ticks_in_ms = Time.get_ticks_msec()
