class_name StoneProjectile
extends AProjectile

@onready var rigid_body_2d: RigidBody2D = %RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_launchable_rigid_body_2D() -> RigidBody2D:
	return rigid_body_2d
