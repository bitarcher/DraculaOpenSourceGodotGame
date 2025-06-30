extends Node2D

@onready var land_slide: Node2D = %LandSlide

func _ready() -> void:
	for item in land_slide.get_children():
		var stone: RigidBody2D = item as RigidBody2D
		stone.gravity_scale = 0.0
		stone.set_collision_mask_value(2, true)
				
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerPlatformer:
		for item in land_slide.get_children():
			var stone: RigidBody2D = item as RigidBody2D
			stone.gravity_scale = 1.0
