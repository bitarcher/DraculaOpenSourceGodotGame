extends Node2D

@onready var land_slide: Node2D = %LandSlide
@onready var land_slide_2: Node2D = %LandSlide2

func _set_gravity_scales_to_all_of_item(land_slide_item: Node2D, gravity_scale: float) -> void:
	for item in land_slide_item.get_children():
		var stone: RigidBody2D = item as RigidBody2D
		stone.gravity_scale = gravity_scale
		stone.set_collision_mask_value(2, true)
		
func _set_gravity_scales_to_all(gravity_scale: float) -> void:
	_set_gravity_scales_to_all_of_item(land_slide, gravity_scale)
	_set_gravity_scales_to_all_of_item(land_slide_2, gravity_scale)

func _ready() -> void:
	_set_gravity_scales_to_all(0.0)
				
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerPlatformer:
		_set_gravity_scales_to_all_of_item(land_slide, 1.0)


func _on_area_2d_at_the_beginning_body_entered(body: Node2D) -> void:
	if body is PlayerPlatformer:
		_set_gravity_scales_to_all_of_item(land_slide_2, 1.0)
