extends Node2D
class_name AProjectile
	
func get_launchable_rigid_body_2D() -> RigidBody2D:
	push_error("get_launchable_rigid_body_2D method must be overriden")
	return null
